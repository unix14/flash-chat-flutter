import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/common/constants.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flash_chat/managers/login_manager.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/widgets/messages_stream.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';
import '../common/stub_data.dart';

class ChatScreen extends StatefulWidget implements Identifiable {
  @override
  static String id = "/chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageTextController = TextEditingController();

  String messageText = "";
  bool _isBtnActivated = false;
  var focusNode = FocusNode();

  int selectedNavBarIndex = 1;

  void loadUser() {
    final User? user = auth.currentUser;
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
    // bool isHomeSelected = selectedNavBarIndex == 0;
    // bool isChatSelected = selectedNavBarIndex == 1;
    // bool isProfileSelected = selectedNavBarIndex == 2;
    // List navBarItems = getNavBarItems(isHomeSelected, isChatSelected, isProfileSelected);
    // List<CurvedNavigationBarItem> curvedNavBarItems = navBarItems as List<CurvedNavigationBarItem>;
    return Scaffold(
      // bottomNavigationBar: !kIsWeb ? CurvedNavigationBar(
      //   backgroundColor: Colors.lightBlueAccent,
      //   index: selectedNavBarIndex,
      //   animationDuration: const Duration(milliseconds: 400),
      //   items: navBarItems as List<CurvedNavigationBarItem>,
      //   onTap: (index) {
      //     setState(() {
      //       selectedNavBarIndex = index;
      //     });
      //   },
      // ) : BottomNavigationBar(
      //   items: navBarItems as List<BottomNavigationBarItem>,
      // ),
      appBar: AppBar(
        leading: Container(),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                LoginManager.doLogout((){
                  Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                });
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
                speed: Duration(milliseconds: 60)),
            TypewriterAnimatedText('⚡️⚡️⚡️',
                textStyle: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: Duration(milliseconds: 60)),
            TypewriterAnimatedText('⚡️Flash⚡️',
                textStyle: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w900,
                ),
                speed: Duration(milliseconds: 60)),
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
            MessagesStream(messages.snapshots()),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageTextController,
                      onChanged: (value) {
                          messageText = value;
                        setState(() {
                          _isBtnActivated = messageText.isNotEmpty;
                        });
                      },
                      autofocus: true,
                      focusNode: focusNode,
                      autovalidateMode: AutovalidateMode.always,
                      onFieldSubmitted: (value) {
                        onSend();
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: _isBtnActivated ? () {
                      onSend();
                    } : null,
                    child: Text(
                      'SEND', //TODO change fonts across the app
                      style: kSendButtonTextStyle.copyWith(color: _isBtnActivated ? Colors.lightBlueAccent[400] : Colors.lightBlueAccent),
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

  onSend() {
    if(messageText.isEmpty) {
      //todo show error or disable send button
      return;
    }
    //todo refactor to ChatManager or smth
    messages.add({
      "text": messageText,
      "senderId": loggedInUser?.email,
      "date": DateTime.now()
    });
    setState(() {
      messageTextController.clear();
      messageText = "";
      _isBtnActivated = false;

      focusNode.requestFocus();
    });
  }
}
