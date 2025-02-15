import 'package:flutter/material.dart';

class ChatsSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const ChatsSearchBar({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Card(
        elevation: 1,
        // color: Theme.of(context).colorScheme.background,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          ),
        ),
    );
  }
}
