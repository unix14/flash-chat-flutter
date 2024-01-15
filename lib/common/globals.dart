

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;


// CollectionReference called messages that references the firestore collection
CollectionReference messages = _firestore.collection(kFirestoreCollection_messages);

// CollectionReference called users that references the firestore collection
CollectionReference users = _firestore.collection(kFirestoreCollection_messages);