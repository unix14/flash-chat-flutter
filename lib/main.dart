import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/common/preferences_manager.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/profile_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'common/constants.dart';
import 'firebase_options.dart';
import 'managers/login_manager.dart';
import 'models/user_credentials.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager.getPrefs();

  UserCredentials user = await PreferencesManager.getUser();
  var initialRoute = WelcomeScreen.id;
  if(user.email.isNotEmpty && user.password.isNotEmpty) {
    Future<bool> loginResult = LoginManager.doLogin(user);
    await loginResult.whenComplete(() {
      initialRoute = ChatScreen.id;
    });
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat(initialRoute));
}

// ignore: must_be_immutable
class FlashChat extends StatefulWidget {

  String initialRoute;

  FlashChat(this.initialRoute);

  @override
  State<FlashChat> createState() {
    return _FlashChatMainState(initialRoute);
  }
}

class _FlashChatMainState extends State<FlashChat> {

  late String initialRoute;

  _FlashChatMainState(this.initialRoute);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: ThemeData(
        useMaterial3: false
      ),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
