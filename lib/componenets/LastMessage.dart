import 'package:flutter/material.dart';

import '../services/chat/chat_service.dart';

class LastMessageWidget extends StatelessWidget {
  final String userId;
  final String otherUserId;

  const LastMessageWidget({
    required this.userId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: ChatService().getLastMessage(userId, otherUserId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return Text(snapshot.data ?? 'Start Chatting');
      },
    );
  }
}
