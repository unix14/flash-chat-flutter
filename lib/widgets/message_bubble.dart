import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isContinusMessage;

  MessageBubble({required this.message, required this.isMe, required this.isContinusMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          isContinusMessage ? Container() : Text(message.senderId,
          style: TextStyle(fontSize: 12,color: Colors.black54),),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 0 : 30),
                topRight: Radius.circular(isMe ? 30 : 0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
            ),
            elevation: 5,
            color: isMe ? Colors.green[400]: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
