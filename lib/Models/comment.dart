  import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
    final String id;  // id of this comment
    final String postId; // id of the post that this comment belong to
    final String uid; // user id of the commenter
    final String name; // name of the commenter
    final String username; // username of the commenter
    final String message; // message of the commenter
    final Timestamp timestamp; // timestamp of comment

    Comment ({
      required this.id,
      required this.postId,
      required this.uid,
      required this.name,
      required this.username,
      required this.message,
      required this.timestamp,
    });

    // Convert firebase data into a comment object (to use in our app)
    factory Comment.fromDocument(DocumentSnapshot doc) {
      return Comment(
          id: doc.id,
          postId: doc['postId'],
          uid: doc['uid'],
          name: doc['name'],
          username: doc['username'],
          message: doc['message'],
          timestamp: doc['timestamp']
      );
    }

    // convert a comment object into a map ( to store in firebase )
    Map<String , dynamic> toMap() {
      return {
        'postId' : postId,
        'uid': uid,
        'name': name,
        'username': username,
        'message': message,
        'timestamp': timestamp
      };
    }

  }