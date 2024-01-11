import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget implements Identifiable {

  @override
  static String id = "/chat_screen";

  static String kFirestoreCollection_messages = "messages";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  // CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection(ChatScreen.kFirestoreCollection_messages);

  //refactor out as a singleton
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;

  final _firestore = FirebaseFirestore.instance;
  String messageText = "";

  void loadUser() {
    final User? user = _auth.currentUser;
    if(user != null) {
      loggedInUser = user;
    }
  }

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  void messagesStream() async {
    // List<Message> messages = [];
    await for (var snapshot in users.snapshots()) {
      for(var message in snapshot.docs) {
        // messages.add(message);
        print(message.data(), );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh_rounded),
              onPressed: () {
                // messagesStream();
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot<Object?>>(
                stream: users.snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    final messages = snapshot.data?.docs ?? [];
                    List<Text> messageWidgets = [];
                    for(var msg in messages) {
                      Map<String, dynamic> data = msg.data()! as Map<String, dynamic>;
                      final msgTxt = data['text'];
                      final senderId = data['senderId'];
                      print("mssgg txt is $msgTxt");
                      print("senderId is $senderId");

                      final msgWidget = Text("${senderId}: $msgTxt");
                      messageWidgets.add(msgWidget);
                    }
                    return Column(
                      children: messageWidgets,
                    );
                  } else {
                    return Spacer();
                  }

            },),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      users.add({
                        "text": messageText,
                        "senderId": loggedInUser?.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
