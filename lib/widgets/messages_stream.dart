import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../common/globals.dart';
import '../models/chat_message.dart';
import 'message_bubble.dart';

class MessagesStream extends StatelessWidget {

  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data?.docs.reversed ?? [];
          List<Widget> messageWidgets = [];
          String? lastSenderId = null;

          for (var msg in messages) {
            Map<String, dynamic> data = msg.data()! as Map<String, dynamic>;
            final text = data['text'] ?? "";
            final senderId = data['senderId'] ?? "";

            ChatMessage newChatMsg = ChatMessage(senderId: senderId, text: text);
            _messages.add(newChatMsg);
          }

          _messages.sort((msgA, msgB) =>
            msgA.date.compareTo(msgB.date)
          );

          for(var msg in _messages) {
            final msgWidget = MessageBubble(
              message: msg,
              isMe: loggedInUser?.email == msg.senderId,
              isContinusMessage: lastSenderId == msg.senderId,
            );
            messageWidgets.add(msgWidget);
            lastSenderId = msg.senderId;
          }
          return Expanded(
            child: ListView(
              // reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        } else {
          return Spacer();
        }
      },
    );
  }
}
