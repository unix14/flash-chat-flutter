import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';
import '../models/chat_message.dart';
import 'message_bubble.dart';

// ignore: must_be_immutable
class MessagesStream extends StatelessWidget {

  late ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: messages.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data?.docs ?? [];
          List<MessageBubble> messageWidgets = [];
          String? lastSenderId = null;

          for (var msg in messages) {
            Map<String, dynamic> data = msg.data()! as Map<String, dynamic>;
            final text = data['text'] ?? "";
            final senderId = data['senderId'] ?? "";
            final Timestamp date = data['date'] ?? Timestamp(0, 0);

            ChatMessage newChatMsg = ChatMessage(senderId: senderId, text: text, date: date.toDate());

            final msgWidget = MessageBubble(
              message: newChatMsg,
              isMe: loggedInUser?.email == newChatMsg.senderId,
            );
            messageWidgets.add(msgWidget);
          }
          //Sort by date of publication
          messageWidgets.sort((msgA, msgB) =>
            msgA.message.date.compareTo(msgB.message.date)
          );
          //Assign lastSenderId to indicate continuous message
          messageWidgets.forEach((element) {
            element.isContinuousMessage = lastSenderId == element.message.senderId;
            //todo make previous message also continuous message
            lastSenderId = element.message.senderId;
          });
          //Animate scroll to end of list when a new message is being added
          Future.delayed(Duration.zero, () {
            if(_controller.hasClients) {
              _controller.animateTo(
                _controller.position.maxScrollExtent + 100,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),);
            }
          });
          return Expanded(
            child: ListView(
              controller: _controller,
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
