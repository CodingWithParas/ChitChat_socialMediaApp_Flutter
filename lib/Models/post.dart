  /*

  POST MODEL

  This is what every post should have

   */

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

  class Post {
    final String id; // id of the post
    final String uid; // uid of the poster
    final String name;
    final String email;
    final String username;
    final String message;
    final Timestamp timestamp;
    final int likeCount;
    final List<String> likeBy; // list of the user IDs whi liked this post

    Post ({
      required this.id,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp,
      required this.likeCount,
      required this.likeBy,
      required this.email,
    });

    // Convert a Firestore document to a post object ( to use in our app )
    factory Post.fromDocument(DocumentSnapshot doc){
      return Post(
          id: doc.id,
          uid: doc['uid'],
          name: doc['name'],
          username: doc['username'],
          message: doc['message'],
          email: doc['email'],
          timestamp: doc['timestamp'],
          likeCount: doc['likes'],
          likeBy: List<String>.from(doc['likedBy'] ?? []),
      );
    }

    //convert a Post object to a map (to store in firebase )
    Map<String , dynamic> toMap() {
      return {
        'uid': uid,
        'name': name,
        'username': username,
        'message' : message,
        'timestamp': timestamp,
        'likes': likeCount,
        'likedBy': likeBy,
        'email': email
      };
    }

  }