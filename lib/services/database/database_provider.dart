  /*

    DATABASE PROVIDER

    This provider is use to separate the firebase data handling and the UI of our app

    - The Auth service class handles data to and from firebase
    - The database provider class processes the data to display in our app

  */

  import 'package:chit_chat/Models/comment.dart';
import 'package:chit_chat/Models/user.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
  import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import '../../Models/post.dart';

  class DatabaseProvider extends ChangeNotifier {

    /*

    SERVICES

    */

    // get firestore and Auth services
   final _firestore = AuthService();
   final _auth = AuthService();
   final _chat = ChatService();

   /*

   USER PROFILE

    */

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _firestore.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _firestore.updateUserBioInFirebase(bio);

  /*   POST  */

  // local list of posts
  List<Post> _allPosts = [];
  List<Post> _followingPosts = [];

  // get posts
  List<Post> get allPosts => _allPosts;
  List<Post> get followingPost => _followingPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post  message in firebase
    await _firestore.postMessageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  // fetch all post
  Future<void> loadAllPosts() async {
    // get all post from firebase
    final allPosts = await _firestore.getAllPostFromFirebase();

    // get the blocked user ids
    final blockedUserIds = await _firestore.getBlockedUidsFromFirebase();

    // filter out the blocked user post and update locally
    _allPosts = allPosts.where((post)=> !blockedUserIds.contains(post.uid)).toList();

    // filter out the following posts
    loadFollowingPost();

    // initialize  local like data
    initializeLikeMap();

    // update UI
    notifyListeners();
  }

  // filter and return the post given uid
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // load following posts -> posts from users that the current user follows
  Future<void> loadFollowingPost() async {
    // get current user uid
    String currentUid = _auth.getCurrentUid();

    // get list of uids that the current logged in user follows (from firebase )
    final followingUserIds = await _firestore.getFollowingUidsFromFirebase(currentUid);

    // filter all posts to be the ones for the following tab
    _followingPosts = _allPosts.where((post)=> followingUserIds.contains(post.uid)).toList();

    // update UI
    notifyListeners();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    // delete from firebase
    await _firestore.deletePostFromFirebase(postId);

    // reload data from firebase
    await loadAllPosts();
  }

  /* ---------------- LIKES------------------- */

  // Local map to track like count for each post
  Map<String, int> _likeCounts = {
    // for each post id: like count

  };
  // local list to track posts liked by current user
  List<String> _likedPosts = [];

  // does the current user liked this post ?
   bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

   // get like count of a post
   int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initialize like map locally
  void initializeLikeMap() {
    // get current uid
    final currentUserID = _auth.getCurrentUid();

    // clear liked posts (for when new user signs in clear local data)
    _likedPosts.clear();

    // for each post get like data
    for (var post in _allPosts) {
      // update like count map
      _likeCounts[post.id] = post.likeCount;

      // if the current user already likes this post
      if (post.likeBy.contains(currentUserID)) {
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

  // toggle like
  Future<void> toggleLike(String postId) async {
    /*

    This first part will update the local values first so that the UI Feels
    immediate and responsive. we will update UI Optimistically, and revert
    back if anything goes wrong writting to the database

    Optimistically updating the local values like this is important because:
    reading and writting from the database takes some time (1-2 second)

    so we dont want to give the user a slow lagged experience

     */

    // store original values in case it fails
    final likedPostsOriginal = _likedPosts;
    final likedCountsOriginal = _likeCounts;

    // performs like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    // update UI locally
    notifyListeners();

    /*
    Now let's try to update it in our database
     */

    // attempt like in database
    try {
      await _firestore.toggleLikeInFirebase(postId);
    }
    // revert back to initial state if update fails
    catch (e) {
      _likedPosts = likedPostsOriginal;
      _likeCounts = likedCountsOriginal;

      // update UI again
      notifyListeners();
    }
  }

  /* --------------COMMENTS--------------

    {
      postId1 : [comment1, comment2, ... ],
      postId2 : [comment1, comment2, ... ],
      postId3 : [comment1, comment2, ... ],

    }

   */

  // local list of comments
  final Map<String, List<Comment>> _comments = {};

  // get comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  // fetch comments from the database for a post
  Future<void> loadComments(String postId) async {
    // get all comment from this post
    final allComments = await _firestore.getCommentsFromFirebase(postId);

    // update local data
    _comments[postId] = allComments;

    // update UI
    notifyListeners();
  }

  // add a comments
  Future<void> addComment(String postId, message) async {
    // add the comments in firebase
    await _firestore.addCommentInFirebase(postId, message);

    // reload the comments
    await loadComments(postId);
  }

  // delete a comments
  Future<void> deleteComment(String commentId,postId) async{
    // delete a comment from firebase
    await _firestore.deleteCommentInFirebase(commentId);

    // reload the comment
    await loadComments(postId);
  }

  /*
      Account stuff
   */

  // local list of blocked users
  List<UserProfile> _blockedUsers = [];

  // get list of blocked users
  List<UserProfile> get blockUsers => _blockedUsers;

  // fetch blocked Users
  Future<void> loadBlockedUsers()async{
    // get list of blocked user ids
    final blockedUserIds= await _firestore.getBlockedUidsFromFirebase();

    // get full user details using uid
    final blockedUsersData = await Future.wait(blockedUserIds.map((id)=> _firestore.getUserFromFirebase(id)));

    // return as a list
    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    // update the UI
    notifyListeners();
  }
  // block User
  Future<void> blockUser(String userId) async {
    // perform block in firebase
    await _firestore.blockUserInFirebase(userId);

    // reload blocked users
    await loadBlockedUsers();

    // reload data
    await loadAllPosts();

    // update UI
    notifyListeners();
  }
  // unblock user
  Future<void> unblockUser(String blockUserId) async {
    // perform the unblock in firebase
    await _firestore.unblockUserInFirebase(blockUserId);

    // reload blockedUSer
    await loadBlockedUsers();

    // reload posts
    await loadAllPosts();
  }

  // report user & post
  Future<void> reportUser(String postId, userId) async {
    await _firestore.reportUserInFirebase(postId, userId);
  }

  /*
      Follow

      Everything here is done with uids ( String )

      --------------------------------------------------

      Each user id has a list of :
      - followers uid
      - following uid

      Eg:
      {

      'uid1' : [ list of uids there are followers / following],
      'uid2' : [ list of uids there are followers / following],
      'uid3' : [ list of uids there are followers / following],
      'uid4' : [ list of uids there are followers / following],
      'uid5' : [ list of uids there are followers / following],

      }
   */

  // local Map
  final Map<String , List<String>> _followers = {};
  final Map<String , List<String>> _following = {};
  final Map<String , int> _followerCount = {};
  final Map<String , int> _followingCount = {};

  // get count for followers and following locally : given a uid
  int getFollowerCount(String uid) => _followerCount[uid] ?? 0 ;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0 ;

  // load followers
  Future<void> loadUserFollowers(String uid) async {
    // get the list of followers uid from firebase
    final listOfFollowerUids = await _firestore.getFollowerUidsFromFirebase(uid);

    // update the local data
    _followers[uid] = listOfFollowerUids;
    _followerCount[uid] = listOfFollowerUids.length;

    // update UI
    notifyListeners();
  }

  // load following
   Future<void> loadUserFollowing(String uid) async {
     // get the list of following uid from firebase
     final listOfFollowingUids = await _firestore.getFollowingUidsFromFirebase(
         uid);

     // update the local data
     _following[uid] = listOfFollowingUids;
     _followingCount[uid] = listOfFollowingUids.length;

     // update UI
     notifyListeners();

   }

     // follow user
     Future<void> followUser(String targetUserId) async {
       /*

        currently logged in user want's to follow target user

        */

       // get current uid
       final currentUserId = _auth.getCurrentUid();

       // initialize with empty lists if null
       _following.putIfAbsent(currentUserId, ()=> []);
       _followers.putIfAbsent(targetUserId, ()=> []);

       /*

          Optimistic UI changes : Update the local data & revert back if database request fails

        */

       // follow if current user is not one of the target user's followers
       if (!_followers[targetUserId]!.contains(currentUserId)) {
         // add current user to the target user's followr list
         _followers[targetUserId]?.add(currentUserId);

         // update follower count
         _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

         // then add target user to current user following
         _following[currentUserId]?.add(targetUserId);

         // update the following count
         _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) + 1;
       }

       // update UI
       notifyListeners();

       /*

          UI has been optimistically updated above with local data.
          Now lets's try to make this request to our database

        */

       try {

         // follow  user in firebase
         await _firestore.followUserInFirebase(targetUserId);

         // reload current user's followers
         await loadUserFollowers(currentUserId);

         // reload the current user's following
         await loadUserFollowing(currentUserId);
       }

       // if there is an error ... revert back to original
       catch (e) {
         // remove current user from target user's followers
         _followers[targetUserId]?.remove(currentUserId);

         // update followers count
         _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

         // remove from current user's following
         _following[currentUserId]?.remove(targetUserId);

         // update following count
         _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) - 1;

         // update UI
         notifyListeners();
       }
     }

     // unfollow user
    Future<void> unfollowUser(String targetUserId) async {
      /*

        currently logged in user want's to unfollow target user

       */

      // get current uid
      final currentUserId = _auth.getCurrentUid();

      // initialize lists if they don't exist
      _following.putIfAbsent(currentUserId, ()=> []);
      _followers.putIfAbsent(targetUserId, ()=> []);

      /*

        Optimistic UI changes : Update the local data first & revert back if the database
        request fails.

       */

      // unfollow if current user is one of the target user's following
      if (_followers[targetUserId]!.contains(currentUserId)) {
        // remove current user from target user's following
        _followers[targetUserId]?.remove(currentUserId);

        // update follower count
        _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 1) - 1;

        // remove target user from current user following list
        _following[currentUserId]?.remove(targetUserId);

        // update following count
        _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 1) - 1;
      }

      // update UI
      notifyListeners();

      /*

          UI has been optimistically update with local data above
          now lets try to make this request to our database

       */

      try {

        // unfollow target user in firebase
        await _firestore.unFollowUserInFirebase(targetUserId);

        // reload user followers
        await loadUserFollowers(currentUserId);

        // reload user following
        await loadUserFollowing(currentUserId);

      }

      // if there is an error ... revert back to original
      catch (e) {
        // add the current user back into target user's followers
        _followers[targetUserId]?.add(currentUserId);

        // update follower count
        _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) +1;

        // add target user back into current user's following list
        _following[currentUserId]?.add(targetUserId);

        // update following count
        _followerCount[currentUserId] = (_followingCount[currentUserId] ?? 0 ) +1;

        // update UI
        notifyListeners();

      }
    }

     // is current user following target user ?
      bool isFollowing(String uid) {
        final currentUserId = _auth.getCurrentUid();
        return _followers[uid]?.contains(currentUserId) ?? false;
      }

      /*

        MAP OF PROFILES

        for a given uid :

        - list of followers profiles
        - list of following profiles

       */

    final Map<String, List<UserProfile>> _followersProfile = {};
    final Map<String, List<UserProfile>> _followingProfile = {};

    // get list of follower profiles for a given user
    List<UserProfile> getListOfFollowersProfile(String uid) => _followersProfile[uid] ?? [];

   // get list of following profiles for a given user
   List<UserProfile> getListOfFollowingProfile(String uid) => _followingProfile[uid] ?? [];

   // load followers profile for a given user
    Future<void> loadUserFollowerProfiles(String uid) async {
      try {
        // get list of follower uids from firebase
        final followerIds = await _firestore.getFollowerUidsFromFirebase(uid);

        // create a list of user profile
        List<UserProfile> followerProfiles = [];

        // go throw each follower id
        for (String followerId in followerIds) {
          // get user follower from firebase with this uid
          UserProfile? followerProfile = await _firestore.getUserFromFirebase(followerId);

          // add to follower profile
          if (followerProfile != null) {
            followerProfiles.add(followerProfile);
          }
        }

        // update local data
        _followersProfile[uid] = followerProfiles;

        // Update UI
        notifyListeners();

      }
      // if there is any error
      catch (e) {

      }
    }

    // load following profiles for a given user
   Future<void> loadUserFollowingProfiles(String uid) async {
     try {
       // get list of following uids from firebase
       final followingIds = await _firestore.getFollowingUidsFromFirebase(uid);

       // create a list of user profile
       List<UserProfile> followingProfiles = [];

       // go throw each following id
       for (String followingId in followingIds) {
         // get user following from firebase with this uid
         UserProfile? followingProfile = await _firestore.getUserFromFirebase(followingId);

         // add to following profile
         if (followingProfile != null) {
           followingProfiles.add(followingProfile);
         }
       }

       // update local data
       _followingProfile[uid] = followingProfiles;

       // Update UI
       notifyListeners();

     }
     // if there is any error
     catch (e) {

     }
   }

 }