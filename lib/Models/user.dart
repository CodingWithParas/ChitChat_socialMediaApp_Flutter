import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
  USER PROFILE

  this is what evey user should have for their profile.

  _____________________________________________________________________________

  - Uid
  - Name
  - email
  - username
  - bio
  - profile photo (we'll do at the end since it require extra stuff)

 */

  class UserProfile {
    final String uid;
    final String name;
    final String email;
    final String username;
    final String bio;

    UserProfile ({
      required this.uid,
      required this.name,
      required this.email,
      required this.username,
      required this.bio,
    });

  /*
   firbase --> app

   Convert firestore document to a user profile (so that we can use in our app)

   */

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
        uid: doc['uid'],
        name: doc['name'],
        email: doc['email'],
        username: doc['username'],
        bio: doc['bio'],
    );
  }

  /*
   app  --> firebase

   Convert a user profile to a map (so that we can store in firebase)

   */

    Map<String , dynamic> toMap(){
      return {
        'uid': uid,
        'name': name,
        'email': email,
        'username': username,
        'bio': bio
      };
    }

  }