import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/common/constants.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flash_chat/widgets/messages_stream.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';

class ChatScreen extends StatefulWidget implements Identifiable {
  @override
  static String id = "/chat_screen";

  static String kFirestoreCollection_messages = "messages";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //refactor out as a singleton
  final _auth = FirebaseAuth.instance;
  TextEditingController messageTextController = TextEditingController();

  String messageText = "";
  bool _isBtnActivated = false;

  void loadUser() {
    final User? user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // messagesStream();
                //todo Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Center(
          child: AnimatedTextKit(animatedTexts: [
            //todo refactor to possibleTexts list + shuffle
            TypewriterAnimatedText('⚡️ Chat',
                textStyle: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: Duration(milliseconds: 20)),
            TypewriterAnimatedText('⚡️⚡️⚡️',
                textStyle: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: Duration(milliseconds: 20)),
            TypewriterAnimatedText('⚡️Flash⚡️',
                textStyle: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: Duration(milliseconds: 20)),
          ], repeatForever: true
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                          messageText = value;
                        setState(() {
                          _isBtnActivated = messageText.isNotEmpty;
                        });
                      },
                      decoration: kMessageTextFieldDecoration,
                      // style: Text,
                    ),
                  ),
                  TextButton(
                    onPressed: _isBtnActivated ? () {
                      if(messageText.isEmpty) {
                        //todo show error or disable send button
                        return;
                      }
                      users.add({
                        "text": messageText,
                        "senderId": loggedInUser?.email,
                      });
                      setState(() {
                        messageTextController.clear();
                        messageText = "";
                        _isBtnActivated = false;
                      });
                    } : null,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle.copyWith(),
                    ),
                    style: ButtonStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
