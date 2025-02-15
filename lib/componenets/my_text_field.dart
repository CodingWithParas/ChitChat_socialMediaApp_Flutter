import 'package:flutter/material.dart';
import 'package:chit_chat/Theme/light_mode.dart';
import 'package:flutter/material.dart%20';

class MyTextField extends StatefulWidget {

  final bool obscureText;
  final String hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller, this.focusNode});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {

  late bool _obscureText ;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
          obscureText: _obscureText,
          controller: widget.controller,
          focusNode: widget.focusNode,
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

            hintText: widget.hintText,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primaryFixed
            ),
            // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: widget.obscureText
              ? IconButton(
                onPressed: _toggleObscureText, 
                icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility )
            ) : null,
          ),
        ),
      ),
    );
  }
}
