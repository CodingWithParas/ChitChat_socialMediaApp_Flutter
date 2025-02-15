import 'package:flutter/material.dart';

class MyBioBox extends StatelessWidget {
  
  final String text;
  const MyBioBox({
    super.key,
  required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12)
        ),
      
        // padding inside
        padding: EdgeInsets.all(25),
      
        // text
        child: Text(
          text.isNotEmpty ? text : "Write your bio...",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16),
        ),
      ),
    );
  }
}
