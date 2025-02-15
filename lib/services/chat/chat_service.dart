import 'package:chit_chat/Models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ChatService extends ChangeNotifier{

  // get instance of firebase and Auth

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get all user stream
  Stream<List<Map<String,dynamic>>> getUsersStream(){
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs
          .where((doc) => doc.data()['email'] != _auth.currentUser!.email)
          .map((doc) => doc.data()).toList();
    });
  }

  // get all user stream except blocked user
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _auth.currentUser;

    return _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .snapshots()
        .asyncMap((snapshot) async {

          // get blocked user ids
          final blockUserIds = snapshot.docs.map((doc) => doc.id).toList();

          // get all users
          final userSnapshot = await _firestore.collection('Users').get();

          // return as strema list excluding current user and block user
      return userSnapshot.docs
          .where((doc)=>doc.data()['email'] != currentUser.email &&
          !blockUserIds.contains(doc.id))
          .map((doc)=> doc.data())
          .toList();
    });
  }


  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new mesage
    Message newMesasge = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // contruct chat room ID for the two user (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensure the chatrooID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").add(newMesasge.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chatroom ID for the Users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore.collection("chat_rooms").doc(chatRoomID).collection("messages").orderBy("timestamp", descending: false).snapshots();
  }

  // Report USER and user post
  Future<void> reportUser(String messageId, String userId) async{
    final currentUser = _auth.currentUser;
    final report = {
      'reportedBy' : currentUser!.uid,
      'messageId' : messageId,
      'messageOwnerId' : userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore.collection('Reports').add(report);
  }

  // Block the user
  Future<void> blockUser(String userId) async {

    final currentUser = _auth.currentUser;
    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(userId).set({});
    notifyListeners();

  }

  // Unblock user
  Future<void> unblockUser(String blockUserId) async {
    final currentUser = _auth.currentUser;

    await _firestore
        .collection('Users')
        .doc(currentUser!.uid)
        .collection('BlockedUsers')
        .doc(blockUserId).delete();
  }

  // get blocked user stream
  Stream<List<Map<String, dynamic>>> getBlockUsersStream (String userId) {
    return _firestore.collection('Users').doc(userId).collection('BlockedUsers').snapshots().asyncMap((snapshot) async{
      // get list of blocked user ids
      final blockUserIds = snapshot.docs.map((doc)=> doc.id).toList();

      final userDocs = await Future.wait(
        blockUserIds
        .map((id)=> _firestore.collection('Users').doc(id).get()),
      );

      // return a list
      return userDocs.map((doc) => doc.data() as Map<String,dynamic>).toList();
    });
  }

  // get lastMessages
  Stream<String> getLastMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['message'] ?? 'No message';
      } else {
        return 'Start Chatting';
      }
    });
  }
}
