/*
    USER TILE

 */

  import 'package:chit_chat/Models/user.dart';
import 'package:chit_chat/helper/navigate_pages.dart';
import 'package:flutter/material.dart';

  class MyUserTileForFollowingList extends StatelessWidget {

    final UserProfile user;
    const MyUserTileForFollowingList({super.key, required this.user});

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap: ()=> goUserPage(context, user.uid),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          child: Card(
            elevation: 2,
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(user.email ,
                              style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,
                                fontSize: 12
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                   Icons.arrow_forward, color: Theme.of(context).colorScheme.inversePrimary, size: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
