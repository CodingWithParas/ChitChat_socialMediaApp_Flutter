import 'package:chit_chat/componenets/user_tile.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUserPage extends StatelessWidget {
   BlockedUserPage({super.key});

  // chat and auth services
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  // show confirm unblock box
  void _showUnblockBox (BuildContext context, String userId){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unblock User"),
          content: const Text("Are you sure you want to unblock this user !"),
          actions: [
            // cancel button
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
                ),

            // unblock button
            TextButton(
              onPressed: (){
                chatService.unblockUser(userId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const
                    SnackBar(content: Text("User Unblocked")
                  )
                );
              },
              child: const Text("Unblock"),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {

    // get current users id
    String userId = authService.getCurrentUser()!.uid;

    // UI

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("B L O C K E D  U S E R"),
        centerTitle: true,
        actions: [],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService
            .getBlockUsersStream(userId),
        builder: (context, snapshot) {

          //error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading.."),
            );
          }

          // loading ....
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading.."),
            );
          }

          final blockUsers = snapshot.data ?? [];

          // no users
          if (blockUsers.isEmpty) {
            return const Center(
              child: Text("No Blocked User"),
            );
          }

          // load complete

          return ListView.builder(
              itemCount: blockUsers.length,
              itemBuilder: (context, index){
                final user = blockUsers[index];
                return UserTile(
                  text: user["name"],
                  onTap: ()=> _showUnblockBox(context, user['uid']), subtitle: '',
                );
              });
        },
      ),
    );
  }
}
