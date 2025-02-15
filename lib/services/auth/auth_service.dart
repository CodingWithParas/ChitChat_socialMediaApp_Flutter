

import 'package:chit_chat/Models/comment.dart';
import 'package:chit_chat/Models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Models/user.dart';

class AuthService {
  // instance of auth & firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore collection names
  static const String usersCollection = 'Users';

  Map<String, List<Comment>> _comments = {};

  // current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String getCurrentUid() {
    return _auth.currentUser!.uid;
  }

  // Helper method to check if the string is an email
  bool isEmail(String input) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(input);
  }

  // sign in
  Future<UserCredential?> signInWithEmailOrUsername(BuildContext context, String identifier, String password) async {
    try {
      if (isEmail(identifier)) {
        // Sign in with email
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: identifier,
          password: password,
        );
        return userCredential;
      } else {
        // Sign in with username
        final userQuerySnapshot = await _firestore.collection(usersCollection)
            .where('name', isEqualTo: identifier)
            .get();

        if (userQuerySnapshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found with that username.')));
          return null;
        }

        // Get the email from the retrieved document
        final email = userQuerySnapshot.docs.first.get('email') as String;

        // Sign in with the retrieved email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An unexpected error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email or username.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unexpected error occurred')));
      return null;
    }
  }

  // sign up
  Future<UserCredential?> signUpWithEmailPassword(BuildContext context, String email, String password, String username) async {
    try {
      // Check if the username already exists
      final userQuerySnapshot = await _firestore.collection(usersCollection)
          .where('username', isEqualTo: username)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username already exists')));
        return null;
      }

      // Create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info in a separate doc
      await _firestore.collection(usersCollection).doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': username,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An unexpected error occurred';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An unexpected error occurred')));
      return null;
    }
  }

  // sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /*
  USER PROFILE

    When the new user register we create an account for them, but let's also store
    their details in the database to display on their profile page

   */

  // Save user info
  Future<void> saveUserInfoInFirebase({required String name ,
    required String email}) async {
    // get current uid
    String uid = _auth.currentUser!.uid;

    // extra username from the email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile(
        uid: uid,
        name: name,
        email: email,
        username: username,
        bio: ''
    );

    // conert user into a map so that we can store in firebase
    final userMap = user.toMap();

    // save user into in firebase
    await _firestore.collection("Users").doc(uid).set(userMap);

  }

  // get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try{

      //retrieve user doc into from firebase
      DocumentSnapshot userDoc = await _firestore.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    }catch (e) {
      print(e);
      return null;
    }
  }

  // update user  bio
  Future<void> updateUserBioInFirebase(String bio) async {

    // get current uid
    String uid = AuthService().getCurrentUid();

    // attempt to update in firebase
    try {
      await _firestore.collection("Users").doc(uid).update({'bio': bio});
    }catch (e){
      print(e);
    }
  }

  // Delete User info
  Future<void> deleteUserInfoFromFirebase(String uid) async {
    WriteBatch batch = _firestore.batch();

    // delete user doc
    DocumentReference userDoc = _firestore.collection("Users").doc(uid);
    batch.delete(userDoc);

    // delete user posts
    QuerySnapshot userPosts = await _firestore.collection("Posts").where('uid', isEqualTo: uid).get();
    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }
    // delete user comments
    QuerySnapshot userComments = await _firestore.collection("Comments").where('uid', isEqualTo: uid).get();
    for (var comment in userComments.docs) {
      batch.delete(comment.reference);
    }

    // delete likes done by this user
    QuerySnapshot allPosts = await _firestore.collection("Posts").get();
    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy'] as List<dynamic>? ?? [];

      if (likedBy.contains(uid)) {
        batch.update(post.reference, {
          'likedBy': FieldValue.arrayRemove([uid]),
          'likes': FieldValue.increment(-1),
        });
      }
    }

    // update follower and following records accordingly...(later)

    // commit batch
    await batch.commit();
  }

  // POST A MESSAGE
  Future<void> postMessageInFirebase(String message) async {

    // try to post message
    try{
      // get current user uid
      String uid = _auth.currentUser!.uid;

      // use this uid to get the user's profile
      UserProfile? user = await getUserFromFirebase(uid);

      // create a new post
      Post newPost = Post(
          id: '',
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          email: user.email,
          timestamp: Timestamp.now(),
          likeCount: 0,
          likeBy: []
      );

      // convert post object --> map
      Map<String , dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _firestore.collection("Posts").add(newPostMap);

    }
    catch (e) {
      print(e);
    }
  }

  // Delete a post
  Future<void> deletePostFromFirebase(String postId) async {
    try{
      await _firestore.collection("Posts").doc(postId).delete();
    }
    catch (e) {
      print(e);
    }
  }

  // Get all post
  Future<List<Post>> getAllPostFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _firestore
          // go to collection --> posts
          .collection("Posts")
          // chronological order
          .orderBy('timestamp', descending: true)
          // get this data
          .get();

      // return as a list of post
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    }
    catch (e) {
      return [];
    }
  }


  // Get individual post

/*
  LIKES
 */

  // Like a post
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      // get current user uid
      String uid = _auth.currentUser!.uid;

      // go to doc for this post
      DocumentReference postDoc = _firestore.collection("Posts").doc(postId);

      // execute like
      await _firestore.runTransaction((transaction) async {
        // get post data
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        // get like of users who like this post
        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);

        // get like count
        int currentlikeCount = postSnapshot['likes'];

        // if user has not liked this post yet ==> then like
        if (!likedBy.contains(uid)) {
          // add the user to like list
          likedBy.add(uid);

          // increment like count
          currentlikeCount++;
        }

        // if the user has already liked this post --> then unlike
        else {
          // remove user from like list
          likedBy.remove(uid);

          // decrement like count
          currentlikeCount--;
        }

        // update in firebase
        transaction.update(postDoc, {
          'likes': currentlikeCount,
          'likedBy': likedBy
        });
      });
    }
    catch (e) {
      print(e);
    }
  }

  /* --------- COMMENT --------------- */

  // Add a comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      // get current user
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      // create a new comment
      Comment newComment = Comment(
          id: "",
          postId: postId,
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
        timestamp: Timestamp.now(),
      );

      // convert comment to map
      Map<String, dynamic> newCommentMap = newComment.toMap();

      // store in firebase
      await _firestore.collection("Comments")
          .add(newCommentMap);

    }
    catch (e) {
      print(e);
    }
  }

  // delete a comment from a post
  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _firestore.collection("Comments").doc(commentId).delete();
    }
    catch (e) {
      print(e);
    }
  }

  // fetch comment for a post
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try{
      // get comment from firebase
      QuerySnapshot snapshot = await _firestore.collection("Comments").
      where("postId", isEqualTo: postId)
          .get();

      // return as a list of comments
      return snapshot.docs.map((doc)=> Comment.fromDocument(doc)).toList();
    }
    catch (e) {
      print(e);
      return[];
    }
  }

  // Report Post
  Future<void> reportUserInFirebase(String postId, userId) async {
    // get current user id
    final currentUserId = _auth.currentUser!.uid;

    // create a report map
    final report = {
      'reportBy' : currentUserId,
      'messageId' : postId,
      'messageOwnerId' : userId,
      'timestamp': FieldValue.serverTimestamp()
    };

    // update in firestore
    await _firestore.collection("Reports").add(report);
  }
    // Block user
    Future<void> blockUserInFirebase(String userId) async {
      //  get current user id
      final currentUserId = _auth.currentUser!.uid;

      // add user to block list
      await _firestore.collection("Users").doc(currentUserId).collection('BlockedUsers').doc(userId).set({});
    }

    // unblock user in firebase
    Future<void> unblockUserInFirebase(String blockUserId) async {
      // get current user id
      final currentUserId = _auth.currentUser!.uid;

      // unblock user in firebase
      await _firestore
          .collection("Users")
          .doc(currentUserId).collection("BlockUsers").doc(blockUserId).delete();
    }

    // get the list of block user from firebase
    Future<List<String>> getBlockedUidsFromFirebase() async {
      //get current user
      final currentUserId = _auth.currentUser!.uid;

      // get data of blocked user
      final snapshot = await _firestore.collection("Users").doc(currentUserId).collection("BlockedUsers").get();

      // return as a list of Uids
      return snapshot.docs.map((doc)=> doc.id).toList();
    }

    // delete Accounts
    Future<void> deleteAccount() async{
      // get currentUser uid
      User? user = getCurrentUser();
      if (user != null) {
        // delete user's data from firebase
        await AuthService().deleteUserInfoFromFirebase(user.uid);

        // delete the user's auth record
        await user.delete();
      }
    }

    /*
      FOLLOW
     */
  // Follow user
  Future<void>  followUserInFirebase (String uid) async {
    // get the current logged in user
    final currentUserId = _auth.currentUser!.uid;

    // add target user to the current user following list
    await _firestore
        .collection("Users")
        .doc(currentUserId)
        .collection("Following")
        .doc(uid).set({});

    // add current user to the target user's followers
    await _firestore
        .collection("Users")
        .doc(uid).collection("Followers")
        .doc(currentUserId)
        .set({});

  }

  // unfollow user
  Future<void> unFollowUserInFirebase(String uid) async {
    // get current logged in user
    final currentUserId = _auth.currentUser!.uid;

    // remove target user from current user's following
    await _firestore
        .collection("Users")
        .doc(currentUserId)
        .collection("Following")
        .doc(uid)
        .delete();

    // remove current user from target user's followers
    await _firestore
        .collection("Users")
        .doc(uid)
        .collection("Followers")
        .doc(currentUserId)
        .delete();

  }

  // Get a user's  followers list of uid
  Future<List<String>> getFollowerUidsFromFirebase(String uid) async {
    // get the followers from firebase
    final snapshot = await _firestore.collection("Users").doc(uid).collection("Followers").get();

    // return as a nice simple list of uid
    return snapshot.docs.map((doc)=> doc.id).toList();

  }

  // Get a user's following list of uid
  Future<List<String>> getFollowingUidsFromFirebase(String uid) async {
    // get the following from firebase
    final snapshot = await _firestore.collection("Users").doc(uid).collection("Following").get();

    // return as a nice simple list of uid
    return snapshot.docs.map((doc)=> doc.id).toList();

  }


}
