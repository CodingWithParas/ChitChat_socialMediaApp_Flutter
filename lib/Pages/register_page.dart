
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../componenets/my_button.dart';
import '../componenets/my_text_field.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {

  // tap to go Login page
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;

  // register method
  void register(BuildContext context) async {
    // get auth service and database service
    final _auth = AuthService();
    final _firestore = AuthService();

    // password match ---> create User
    if(_pwController.text == _confirmPwController.text) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signUpWithEmailPassword(
            context, _emailController.text,
            _pwController.text, _usernameController.text
        );
        // once registered , create and save user profile in database
        await _firestore.saveUserInfoInFirebase(
            name: _usernameController.text,
            email: _emailController.text
        );
        // btw eve

      } catch (e) {
        showDialog(context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    // password don't match, show error ---> tell user to fix
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords don't match")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Image.asset("images/chitchat.png", scale: 2.5,),

              const SizedBox(height: 50,),
              // welcome message
              Text("Welcome back, you've been missed?",
                  style: TextStyle(fontSize: 16,
                    color: Colors.grey.shade500,)
              ),
              const SizedBox(height: 25,),

              // userName text field
              MyTextField(
                hintText: 'Username',
                obscureText: false,
                controller: _usernameController,),

              const SizedBox(height: 10,),

              // email textfield
              MyTextField(
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,),

              const SizedBox(height: 10,),

              // password text
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _pwController,),

              const SizedBox(height: 10,),

              // Confirm password text
              MyTextField(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: _confirmPwController,),

              const SizedBox(height: 25,),

              _isLoading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black, size: 50)
              // register button
                  : MyButton(
                text: 'REGISTER',
                onTap: () => register(context),),

              const SizedBox(height: 25,),

              // register text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(" Login now",
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
