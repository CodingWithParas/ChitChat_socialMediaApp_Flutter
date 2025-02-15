import 'package:chit_chat/componenets/chat_bubble.dart';
import 'package:chit_chat/componenets/my_text_field.dart';
import 'package:chit_chat/componenets/send_message_textfield.dart';
import 'package:chit_chat/services/auth/auth_service.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart%20';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  void _blockUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ChatService().blockUser(widget.receiverID);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User Blocked!")),
              );
            },
            child: const Text("Block"),
          ),
        ],
      ),
    );
  }

  void _reportUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report User"),
              content: const Text(
                  "Report the message you want to report by long pressing it."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'block') {
                _blockUser(context);
              } else if (value == 'report') {
                _reportUser(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'block',
                  child: Row(
                    children: [
                      Icon(Icons.block,
                          color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 8),
                      const Text('Block', style: TextStyle(fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(Icons.report,
                          color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 8),
                      const Text('Report',style: TextStyle(fontWeight: FontWeight.w400),),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          const SizedBox(height: 10),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text("An error occurred. Please try again."));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
            messageId: doc.id,
            userId: data["senderID"], timestamp: (data["timestamp"] as Timestamp).toDate(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: SendMessageTextfield(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 20),
            child: FloatingActionButton(
              onPressed: sendMessage,
              child:  Icon(Icons.send, color: Theme.of(context).colorScheme.secondary),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
