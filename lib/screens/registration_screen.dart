import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/constants.dart';

class RegistrationScreen extends StatefulWidget implements Identifiable {

  @override
  static String id = "/registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //refactor out as a singleton
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      blurEffectIntensity: 4,
      progressIndicator: SpinKitFadingCircle(
        color: Colors.lightBlue,
        size: 90.0,
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black87,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  setState(() {
                    email = value;
                  });
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  setState(() {
                    password = value;
                  });
                },
                decoration: kInputDecoration.copyWith(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: "regBtn",
                child: RoundedButton(
                    title: 'Register',
                    color: Colors.blueAccent,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                        if(newUser.user != null) {
                          Navigator.popAndPushNamed(context, ChatScreen.id);
                        } else {
                          //todo show error message
                        }
                      } catch (e) {
                        //todo show error message
                        print (e);
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
