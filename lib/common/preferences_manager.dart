import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class PreferencesManager {
  static SharedPreferences? instance;

  // static String storedEmail = "";
  // static String storedPass = "";

  // Obtain shared preferences.
  static Future<SharedPreferences> getPrefs() async {
    await SharedPreferences.getInstance().then((value) {
      instance = value;
    });

    return instance!;
  }

  // void loadPrefs(SharedPreferences prefs) async {
  //   storedEmail = prefs.getString(kStoredEmailTag) ?? "";
  //   storedPass = prefs.getString(kStoredPassTag) ?? "";
  // }

  static void saveUserToPrefs(String newEmail, String newPass) async {
    instance?.setString(kStoredEmailTag, newEmail);
    instance?.setString(kStoredPassTag, newPass);
  }
}
