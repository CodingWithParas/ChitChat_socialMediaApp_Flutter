import 'package:chit_chat/Models/post.dart';
import 'package:chit_chat/componenets/my_input_alertbox_bio.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'comment_box_tile.dart';

/*
  POST TILE

  to use this widget we need
  - the post

  - a function for onPostTap ( go to the individual post to see it's comments )

  - a function for onUserTap ( go to user's profile page )

 */

class MyPostTile extends StatefulWidget {

  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;
  const MyPostTile({super.key, required this.post, this.onUserTap, this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {

  // provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);


  // on startup
  @override
  void initState() {
    super.initState();
    // load the comments for the post
    _loadComments();
  }

  /* ---------LIKEs----------*/
  // user tapped like ( or unlike )
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    }
    catch (e) {
      print(e);
    }
  }

  /* ------------- COMMENTS ---------*/

  // comment text controller
  final _commentController = TextEditingController();

  // open comments box ->  user wants to type a comments
  void _openNewCommentBox() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: DraggableScrollableSheet(
                    expand: false,
                    builder: (context, scrollController) {
                      return FutureBuilder(
                        future: databaseProvider.loadComments(widget.post.id),
                        builder: (context, snapshot) {
                            final comments = listeningProvider.getComments(widget.post.id);
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "Comments", style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.inversePrimary
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: comments.isEmpty
                                      ? Center(child: Text(
                                      "No Comments on this Post",
                                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                                    )
                                  )
                                      : ListView.builder(
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      final comment = comments[index];
                                      return CommentBoxTile(comment: comment);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    children: [
                                      Image.asset('images/user.png', scale: 15),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                                          autofocus: true,
                                          controller: _commentController,
                                          onSubmitted: (value) => _addComment(),
                                          decoration: InputDecoration(
                                              border: InputBorder.none, // Removes the underline
                                              focusedBorder: InputBorder.none, // Removes the underline when focused
                                              enabledBorder: InputBorder.none, // Removes the underline when enabled
                                              disabledBorder: InputBorder.none, // Removes the underline when disabled
                                              hintText: 'Add comment',
                                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: _addComment,
                                          icon: Icon(
                                            Icons.send_rounded, color: Theme.of(context).colorScheme.inversePrimary,
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  // user tapped post to add comment
  Future<void> _addComment() async {
    // does nothing if there is nothing in the textfield
    if (_commentController.text.trim().isEmpty) return;

    // attempt to post comment
    try {

      await databaseProvider.addComment(widget.post.id, _commentController.text.trim());
      _commentController.clear();
    }
    catch (e){
      print(e);
    }
  }

  // load comments
  Future<void> _loadComments() async{
    await databaseProvider.loadComments(widget.post.id);
  }

  /*
      SHOW OPTIONS

     Case 1 : This post is belongs to the user
      -- Delete
      -- Cancel

     Case 2 : This post is not belong to the user
      -- Block
      -- Report
      -- Cancel
   */

  void _showOptions() {

    // check if the post is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    // show option
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SafeArea(
            child: Wrap(
              children: [

                // this post belongs to current user
                if (isOwnPost)

                // delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    // pop option box
                    Navigator.pop(context);

                    // handle delete action
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )

                else ...[
                  // report post button
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Report"),
                    onTap: (){
                      Navigator.pop(context);

                      // handle the report button
                      _reportPostConfirmationBox();
                    },
                  ),

                  // block user button
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: (){
                      Navigator.pop(context);

                      // handle the block button
                      _blockUSerConfirmationBox();
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

  // report Post Confiremation Box
  void _reportPostConfirmationBox() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Report Message"),
          content: const Text("Are you sure you want to report this message?"),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            // report button
            TextButton(
              onPressed: () async{

                // report user
                await databaseProvider.reportUser(widget.post.id, widget.post.uid);

                //close box
                Navigator.pop(context);

                // let user know it was successfully reported
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Message Reported"),
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 50, left: 10, right: 10),
                  ),
                );
              },
              child: const Text("Report"),
            ),
          ],
        )
    );
  }

  // blocking the user
  void _blockUSerConfirmationBox() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Block User"),
          content: const Text("Are you sure you want to Block this User?"),
          actions: [
            // cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            // report button
            TextButton(
              onPressed: () async{

                // report user
                await databaseProvider.blockUser(widget.post.uid);

                //close box
                Navigator.pop(context);

                // let user know user was successfully blocked
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Blocked User Successfully"),
                    duration: Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 50, left: 10, right: 10),
                  ),
                );
              },
              child: const Text("Block"),
            ),
          ],
        )
    );
  }

  // time stamp of the post
  String _formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return timeago.format(date, locale: 'short');
  }

  @override
  Widget build(BuildContext context) {

    // Does the current user liked this post?
    bool likedByCurrentUser = listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    // listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(top: 15, left: 25, right: 25),
      // padding: EdgeInsets.all(25),
      color: Theme.of(context).colorScheme.secondary,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onUserTap,
                child: Row(
                  children: [
                    // profile pic
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('images/user.png'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    // message and user name
                    Text(widget.post.name,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w500)
                    ),
                    Spacer(),
                    // icon button --> more options
                    GestureDetector(
                      onTap: _showOptions,
                      child:  Icon(
                          Icons.more_horiz,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 35,
                  ),
                  Icon(Icons.receipt_long, size: 14, color: Theme.of(context).colorScheme.inversePrimary,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Text(
                        widget.post.message,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w300),
                        overflow: TextOverflow.visible,

                      ),

                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),

              // buttons --> likes + comments
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        // like section
                        GestureDetector(
                          onTap: _toggleLikePost,
                            child: likedByCurrentUser ? Icon(Icons.favorite, color: Colors.red,)
                                : Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.inversePrimary,
                            )
                        ),
                        const SizedBox(width: 4,),
                        // like count
                        Text(
                          likeCount != 0 ? likeCount.toString() : "",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight:FontWeight.w600),
                        ),
                        // const SizedBox(width: 2,),
                        // Text("Like", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.w400),)
                      ],
                    ),
                  ),
                  // comment section
                  Row(
                    children: [
                      // comment button
                      GestureDetector(
                        onTap: _openNewCommentBox,
                        child: Icon(Icons.comment,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),

                      const SizedBox(width: 4,),

                      // comment count
                      Text(
                        commentCount != 0 ? commentCount.toString() : '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16, fontWeight:FontWeight.w600),
                      ),
                    ],
                  ),

                  Spacer(),
                  
                  // Time stamp of Post 
                  Text(
                    _formatTimestamp(widget.post.timestamp) + " ago",
                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 12, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
