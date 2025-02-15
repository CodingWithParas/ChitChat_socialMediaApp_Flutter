import 'package:flutter/material.dart';
import 'package:chit_chat/Theme/light_mode.dart';

class SendMessageTextfield extends StatelessWidget {

  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const SendMessageTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 2,
        // color: Theme.of(context).colorScheme.background,
        child: TextField(
          // maxLines: null,
          // minLines: 1,
          obscureText: obscureText,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)
              ),
              // fillColor: Theme.of(context).colorScheme.primaryContainer,
              // filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryFixed)
          ),
        ),
      ),
    );
  }
}
