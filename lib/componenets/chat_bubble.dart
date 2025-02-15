import 'package:chit_chat/Theme/theme_provider.dart';
import 'package:chit_chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageId;
  final String userId;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageId,
    required this.userId,
    required this.timestamp,
  });

  // show options
  void _showOptions(BuildContext context, String messageId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // report button
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageId, userId);
                },
              ),

              // block user button
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userId);
                },
              ),

              // cancel button
              ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // report message
  void _reportMessage(BuildContext context, String messageId, String userId) {
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
            onPressed: () {
              Navigator.pop(context);
              ChatService().reportUser(messageId, userId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Message Reported"),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text("Report"),
          ),
        ],
      ),
    );
  }

  // block user
  void _blockUser(BuildContext context, String userId) {
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

          // block button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ChatService().blockUser(userId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("User Blocked!"),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text("Block"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // light and dark mode for correct bubble colors
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show option
          _showOptions(context, messageId, userId);
        }
      },
      child: Column(
        crossAxisAlignment:
        isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82, // 75% of screen width
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isCurrentUser
                    ? (isDarkMode ? Colors.green.shade500 : Colors.green.shade500)
                    : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message,
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 5,
              bottom: 2,
            ),
            child: Text(
              DateFormat('h:mm a').format(timestamp),
              style: TextStyle(
                fontSize: 10,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
