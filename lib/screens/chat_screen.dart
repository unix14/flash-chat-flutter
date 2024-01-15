import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/common/constants.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flash_chat/managers/login_manager.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/widgets/messages_stream.dart';
import 'package:flutter/material.dart';

import '../common/globals.dart';

class ChatScreen extends StatefulWidget implements Identifiable {
  @override
  static String id = "/chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  //refactor out as a singleton
  final _auth = FirebaseAuth.instance;
  TextEditingController messageTextController = TextEditingController();

  String messageText = "";
  bool _isBtnActivated = false;

  int selectedNavBarIndex = 1;

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
    bool isHomeSelected = selectedNavBarIndex == 0;
    bool isChatSelected = selectedNavBarIndex == 1;
    bool isProfileSelected = selectedNavBarIndex == 2;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        index: selectedNavBarIndex,
        animationDuration: const Duration(milliseconds: 400),
        items: [
          getBottomMenuItem('Home',
              Icons.home_rounded,
              Icons.home_outlined,
              isHomeSelected,
          ),
          getBottomMenuItem('Chat',
            Icons.chat_bubble_rounded,
            Icons.chat_bubble_outline,
            isChatSelected,
          ),
          getBottomMenuItem('Profile',
            Icons.person,
            Icons.perm_identity_outlined,
            isProfileSelected,
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedNavBarIndex = index;
          });
        },
      ),
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
                      });
                    } : null,
                    child: Text(
                      'Send',
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
}
