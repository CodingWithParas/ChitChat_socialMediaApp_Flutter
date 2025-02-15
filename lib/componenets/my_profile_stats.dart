  /*
      PROFILE STATS

      This will be displayed the profile page

      ------------------------------------------------------

      Number of :
       - post
       - followers
       - following

   */

  import 'package:flutter/material.dart';

  class MyProfileStats extends StatelessWidget {

    final int postCount;
    final int followerCount;
    final int followingCount;
    final void Function()? onTap;
    const MyProfileStats({super.key, required this.postCount, required this.followerCount, required this.followingCount, this.onTap});

    @override
    Widget build(BuildContext context) {

      // text style for count
      var textStyleForCount = TextStyle(
          fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary
      );

      // text style for text (post , follower , following)
      var textStyleForText = TextStyle(
        fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.inversePrimary
      );

      return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // post
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(postCount.toString(), style: textStyleForCount,), Text("Posts", style: textStyleForText,)
                ],
              ),
            ),

            // Followers
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(followerCount.toString(), style: textStyleForCount,), Text("Follower", style: textStyleForText,),
                ],
              ),
            ),

            // Following
            SizedBox(
              width: 100,
              child: Column(
                children: [
                  Text(followingCount.toString(), style: textStyleForCount,), Text("Following", style: textStyleForText,),
                ],
              ),
            )
          ],
        ),
      );
    }
  }
