import 'package:chit_chat/componenets/chat_loading.dart';
import 'package:chit_chat/componenets/chats_search_bar.dart';
import 'package:chit_chat/componenets/my_text_field.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../componenets/my_drawer.dart';
import '../componenets/user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C H A T S"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          ChatsSearchBar(hintText: 'Search by username', controller: _searchController),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return Center(child: const Text("Unexpected Error Occur !! "));
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ChatLoading();
        }
        // return List view
        var filteredUsers = snapshot.data!
            .where((user) => user['name']
            .toString()
            .toLowerCase()
            .contains(_searchQuery))
            .toList();
        return ListView(
          children: filteredUsers
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // building individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return StreamBuilder<String>(
        stream: _chatService.getLastMessage(
          _authService.getCurrentUser()!.uid,
          userData["uid"],
        ),
        builder: (context, snapshot) {
          String lastMessage = snapshot.data ?? 'No message';
          return UserTile(
            text: userData['name'],
            subtitle: lastMessage, // Display the last message
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: userData["name"],
                    receiverID: userData["uid"],
                  ),
                ),
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }
}
