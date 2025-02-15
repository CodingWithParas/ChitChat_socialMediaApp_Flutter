import 'package:chit_chat/componenets/my_input_alertbox_bio.dart';
import 'package:chit_chat/componenets/my_post_tile.dart';
import 'package:chit_chat/helper/navigate_pages.dart';
import 'package:chit_chat/services/database/database_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';
import 'package:provider/provider.dart';

import '../Models/post.dart';

/*
    MAIN PAGE
    This is the main page of this app It display a list of all post

    -------------------------------------------------------------------

    we can organise the page using tab bar to splits into :
    - for you page
    - following page

 */

class ChitChatPage extends StatefulWidget {
  const ChitChatPage({super.key});

  @override
  State<ChitChatPage> createState() => _ChitChatPageState();
}

class _ChitChatPageState extends State<ChitChatPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  final currentUser = FirebaseAuth.instance.currentUser!;
  final _messageController = TextEditingController();

  // on startup
  @override
  void initState() {
    super.initState();

    // let's load all the posts
    loadAllPosts();
  }

  // load all posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertboxBio(
            hintText: "What's on your mind ? ",
            textController: _messageController,
            onPressed: () async {
              // post in firestore
              await postMessage(_messageController.text);
            },
            onPressedText: "Post"));
  }

  // user wants to post message
  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // bottom: TabBar(
          //   dividerColor: Colors.transparent,
          //   labelColor: Theme.of(context).colorScheme.inversePrimary,
          //   unselectedLabelColor: Theme.of(context).colorScheme.primary,
          //   tabs: const[
          //     Tab(text: "For You",),
          //
          //     Tab(text: "Following"),
          //   ],
          // ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("C H I T C H A T"),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          onPressed: _openPostMessageBox,
          child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
        ),
        body: _buildPostList(listeningProvider.allPosts)
      ),
    );
  }

  // build list Ui given a list of posts
  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ?
        // when post list is empty
        const Center(
            child: Text("Post your thought's"),
          )
        // when post list is Notempty
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual posts
              final post = posts[index];

              // return Post Tile UI
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
              );
            },
          );
  }
}
