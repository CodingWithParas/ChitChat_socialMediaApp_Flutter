import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/*
  to use this widget you need :

  - text controller (to access what the user type)
  - hint text
  - a function ( eg save bio )
  - text for button ( eg Save )

 */

class MyInputAlertboxBio extends StatelessWidget {

  final String hintText;
  final String onPressedText;
  final TextEditingController textController;
  final void Function()? onPressed;
  const MyInputAlertboxBio({super.key,
    required this.hintText,
    required this.textController,
    required this.onPressed,
    required this.onPressedText
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      content: TextField(
        controller: textController,
        maxLength: 140,
        maxLines: 3,
        autofocus: true,

        decoration: InputDecoration(
          // border when textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12)
          ),

          // border when the textfield is selected
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12)
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
        ),
      ),

      // buttons
      actions: [
        // cancel button
        TextButton(onPressed: (){
          Navigator.pop(context);
          textController.clear();
        },
            child: Text("Cancel")
        ),

        // save button
        TextButton(onPressed: (){
          // close box
          Navigator.pop(context);

          // execute the function
          onPressed!();

          // clear the controller
          textController.clear();
        },
            child: Text(onPressedText)
        )
      ],
    );
  }
}
