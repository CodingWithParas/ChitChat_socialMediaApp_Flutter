import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final void Function()? onTap;
  final String text;
  const MyButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16)
          ),
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
