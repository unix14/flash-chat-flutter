import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/common/preferences_manager.dart';
import 'package:flash_chat/interfaces/identifiable.dart';
import 'package:flash_chat/managers/login_manager.dart';
import 'package:flash_chat/models/user_credentials.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget implements Identifiable {

  @override
  static String id = "/login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  //refactor out as a singleton
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
                //todo extract to widget
                tag: "logo",
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
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
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
                decoration: InputDecoration(
                  hintText: 'Enter your password.',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: "loginBtn",
                child: RoundedButton(
                    title: 'Log In',
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      //todo refactor validation to mixin
                      bool emailValidation = !EmailValidator.validate(email);
                      bool passwordEmpty = password.isEmpty;
                      bool passwordLength = password.length < 7 && password.length < 13;
                      if(emailValidation || passwordEmpty || passwordLength) {
                        String errorMsg = "Error unknown";

                        if(emailValidation) {
                          errorMsg = "Mail address is malformed";
                        }
                        if(passwordEmpty) {
                          errorMsg = "Password must not be empty";
                        }
                        if(passwordLength) {
                          errorMsg = "Password length should be between 6 and 12 characters";
                        }

                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Error",
                          desc: errorMsg,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "ok",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      UserCredentials user = UserCredentials(email: email, password: password);
                      /*var result = await*/ LoginManager.doLogin(user, callback: () {
                        //todo make error pop up when error occurs like this :
                        // RecaptchaCallWrapper(13551): Initial task failed for action RecaptchaAction(action=signInWithPassword)with exception - We have blocked all requests from this device due to unusual activity. Try again later. [ Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later. ]
                        Navigator.popAndPushNamed(context, ChatScreen.id);
                      });
                      // if(result) {
                      //
                      // }
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
