  /*

    FOLLOW BUTTON

    This is a follow / unfollow button, depending on whose profile page we are
    currently viewing

    -----------------------------------------------------------------------------

    To use this widget , you need :

    -- a function ( e.g togglefollow() when the button is pressed )
    -- isFollowing ( e.g false ==> then we will show follow button instead of unfollow button

   */

  import 'package:flutter/material.dart';

  class MyFollowButton extends StatelessWidget {

    final void  Function()? onPressed;
    final bool isFollowing;
    const MyFollowButton({super.key, this.onPressed, required this.isFollowing});

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(22.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: MaterialButton(
            padding: EdgeInsets.all(20),
              onPressed: onPressed,
            color:
              isFollowing ? Colors.black54 : Colors.lightBlue,
            child: Text(
              isFollowing ? "UnFollow" : "Follow",
              style: TextStyle(
                  color: Colors.white,
                fontWeight: FontWeight.w800, fontSize: 16
              ),
            ),
          ),
        ),
      );
    }
  }
