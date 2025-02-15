import 'package:chit_chat/Models/comment.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/auth/auth_service.dart';

class CommentBoxTile extends StatelessWidget {

  final Comment comment;
  final void Function()? onUserTap;
  const CommentBoxTile({super.key, required this.comment, this.onUserTap});

  // show option for comment
  void _showOptions(BuildContext context) {

    // check if this comment is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    // show option
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SafeArea(
            child: Wrap(
              children: [

                // this comment belongs to current user
                if (isOwnComment)

                // delete comment button
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete"),
                    onTap: () async {
                      // pop option box
                      Navigator.pop(context);

                      // handle delete action
                      await Provider.of<DatabaseProvider>(context, listen: false).deleteComment(comment.id, comment.postId);
                    },
                  )

                else ...[
                  // report comment button
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Report"),
                    onTap: (){
                      Navigator.pop(context);

                      // handle the comment button

                    },
                  ),

                  // block user button
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: (){
                      Navigator.pop(context);

                      // handle the block button

                    },
                  ),
                ],
                // cancel button
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  // time stamp of the comment
  String _formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return timeago.format(date, locale: 'short');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: ()=> _showOptions(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 18.0,
                    backgroundImage: AssetImage('images/user.png'), // Replace with actual profile image
                  ),
                ),
                SizedBox(width: 2),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              comment.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                  color: Theme.of(context).colorScheme.inversePrimary
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              _formatTimestamp(comment.timestamp),
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary, fontSize: 12
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          comment.message,
                          style: TextStyle(
                            fontSize: 14.0,
                              color: Theme.of(context).colorScheme.inversePrimary
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

