// go to user page
import 'package:chit_chat/Models/post.dart';
import 'package:chit_chat/Pages/chit_chat_page.dart';
import 'package:chit_chat/Pages/user_profile.dart';
import 'package:flutter/material.dart';

  void goUserPage(BuildContext context, String uid) {
    // navigate to the page
    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfilePage(uid: uid)
      ),
    );
  }

  // go home page ( but remove all the previous routes , this is good for reload )

  void goHomePage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChitChatPage()
      ),
    );
  }