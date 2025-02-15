import 'package:chit_chat/Pages/home_page.dart';
import 'package:chit_chat/componenets/my_drawer.dart';
import 'package:chit_chat/services/auth/register_or_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          // user is logged in
          if(snapshot.hasData) {
            return MyDrawer();
          }
          // user is NOT logged in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
