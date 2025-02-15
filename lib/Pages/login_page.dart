import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:chit_chat/componenets/my_button.dart';
import 'package:chit_chat/componenets/my_text_field.dart';
import '../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    try {
      await authService.signInWithEmailOrUsername(
        context,
        _emailController.text,
        _pwController.text,

      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/chitchat.png", scale: 2.5),
              const SizedBox(height: 50),

              // welcome message
              Text(
                "Welcome back you've been missed?",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 25),

              // username and email field
              MyTextField(
                hintText: 'Email / Username',
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),

              // password  field
              MyTextField(
                hintText: 'Password',
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 10,),

              // forget password ?
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?" , style: TextStyle(
                      color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _isLoading
                  ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 50,
              )
                  : MyButton(
                text: 'LOGIN',
                onTap: () => login(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " Register",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
