import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';
import '../models/chat_message.dart';
import 'message_bubble.dart';

class MessagesStream extends StatefulWidget {

  Stream<QuerySnapshot<Object?>> stream;

  MessagesStream(this.stream);

  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream>{

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    //todo refactor server code out of here
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: widget.stream,
      builder: (context, snapshot) {
        //todo add pb while loading messages..
        if (snapshot.hasData) {
          final messages = snapshot.data?.docs ?? [];
          List<MessageBubble> messageWidgets = _getMessageWidgets(messages);
          scrollToEnd();
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

  scrollToEnd() {
    //Animate scroll to end of list when a new message is being added
    Future.delayed(Duration.zero, () {
      if(_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent + 100,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),);
      }
    });
  }

  List<MessageBubble> _getMessageWidgets(List<QueryDocumentSnapshot<Object?>> messages) {
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
    return messageWidgets;
  }
}
