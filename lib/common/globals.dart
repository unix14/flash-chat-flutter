

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/chat_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;


// CollectionReference called users that references the firestore collection
CollectionReference users = _firestore.collection(ChatScreen.kFirestoreCollection_messages);