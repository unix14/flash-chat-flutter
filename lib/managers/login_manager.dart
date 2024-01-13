
import 'package:firebase_auth/firebase_auth.dart';

import '../models/UserCredentials.dart';

class LoginManager {

  static FirebaseAuth auth = FirebaseAuth.instance;

  static void doRegister(UserCredentials user, Function() callback) async {
    try {
      UserCredential? result = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      if(result.user != null) {
        callback();
      } else {
        //todo show error message
      }
    } catch(e) {
      //todo show error message
    }
  }

  static void doLogin(UserCredentials user, Function() callback) async {
    try {
      UserCredential? result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      if(result.user != null) {
        callback();
      } else {
        //todo show error message
      }
    } catch(e) {
      //todo show error message
    }
  }
}