

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'constants.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
User? loggedInUser;


// CollectionReference called messages that references the firestore collection
CollectionReference messages = firestore.collection(kFirestoreCollection_messages);

// CollectionReference called users that references the firestore collection
CollectionReference users = firestore.collection(kFirestoreCollection_messages);