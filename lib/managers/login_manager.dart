
import 'package:firebase_auth/firebase_auth.dart';

import '../common/globals.dart';
import '../common/preferences_manager.dart';
import '../models/user_credentials.dart';

class LoginManager {

  static void doRegister(UserCredentials user, Function() callback) async {
    try {
      UserCredential? result = await auth.createUserWithEmailAndPassword(email: user.email, password: user.password);
      if(result.user != null) {
        PreferencesManager.saveUser(user);
        callback();
      } else {
        //todo show error message
      }
    } catch(e) {
      //todo show error message
    }
  }

  static Future<bool> doLogin(UserCredentials user, {Function()? callback = null}) async {
    try {
      UserCredential? result = await auth.signInWithEmailAndPassword(email: user.email, password: user.password);
      print("wow login result is #$result");
      if(result.user != null) {
        PreferencesManager.saveUser(user);
        if(callback != null)
          callback();
        return true;
      } else {
        //todo show error message
      }
    } catch(e) {
      //todo show error message
    }
    return false;
  }

  static void doLogout(Function() callback) async {
    try {
      await auth.signOut();
      PreferencesManager.deleteUser();
      callback();
    } catch(e) {
      //todo show error message
    }
  }
}