import 'package:flash_chat/models/user_credentials.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class PreferencesManager {

  static SharedPreferences? instance;

  // Obtain shared preferences.
  static Future<SharedPreferences> getPrefs() async {
    await SharedPreferences.getInstance().then((value) {
      instance = value;
    });

    return instance!;
  }

  static Future<UserCredentials> getUser() async {
    var storedEmail = instance?.getString(kStoredEmailTag) ?? "";
    var storedPass = instance?.getString(kStoredPassTag) ?? "";
    var user = UserCredentials(email: storedEmail, password: storedPass);
    return user;
  }

  static void saveUser(UserCredentials user) async {
    //todo use json parser to set and get functions
    instance?.setString(kStoredEmailTag, user.email);
    instance?.setString(kStoredPassTag, user.password);
  }

  static void deleteUser() async {
    instance?.setString(kStoredEmailTag, "");
    instance?.setString(kStoredPassTag, "");
  }
}
