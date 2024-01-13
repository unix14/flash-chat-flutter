import 'package:flash_chat/common/globals.dart';
import 'package:flash_chat/common/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'common/constants.dart';
import 'firebase_options.dart';
import 'mixins/login_operations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prefs = await PreferencesManager.getPrefs();

  String storedEmail = prefs.getString(kStoredEmailTag) ?? "";
  String storedPass = prefs.getString(kStoredPassTag) ?? "";
  var initialRoute = WelcomeScreen.id;
  if(storedEmail.isNotEmpty && storedPass.isNotEmpty) {
    initialRoute = ChatScreen.id;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat(initialRoute));
}

class FlashChat extends StatefulWidget with LoginOperationsMixin {

  String initialRoute;

  FlashChat(this.initialRoute);

  @override
  State<FlashChat> createState() {
    return _FlashChatMainState(initialRoute);
  }
}

class _FlashChatMainState extends State<FlashChat> with LoginOperationsMixin {

  late String initialRoute;

  _FlashChatMainState(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
