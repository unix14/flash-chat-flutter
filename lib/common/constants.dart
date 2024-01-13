import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kOutlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(32.0)),
);


var kInputDecoration = InputDecoration(
  hintText: '',
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: kOutlineBorder,
  enabledBorder: kOutlineBorder.copyWith(borderSide: BorderSide(color: Colors.blueAccent, width: 1.0)),
  focusedBorder:kOutlineBorder.copyWith(borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)),
);


String kStoredEmailTag = "3mA!l";
String kStoredPassTag = "p/ss";
