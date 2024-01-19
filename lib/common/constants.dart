import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/foundation.dart';
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


getBottomMenuItem(String text, IconData selectedIcon, IconData unselectedIcon, bool isSelected) {
  if(kIsWeb) {
    return BottomNavigationBarItem(
      activeIcon: Icon(selectedIcon),
      icon: Icon(isSelected ? selectedIcon : unselectedIcon,color: isSelected ? Colors.lightBlueAccent : null,),
      label: text,
    );
  } else {
    return CurvedNavigationBarItem(
        child: Icon(isSelected ? selectedIcon : unselectedIcon,color: isSelected ? Colors.lightBlueAccent : null,),
        label: text,
        labelStyle: isSelected ? null : TextStyle(color: Colors.black54));
  }
}

String kStoredEmailTag = "3mA!l";
String kStoredPassTag = "p/ss";

String kFirestoreCollection_messages = "messages";
String kFirestoreCollection_users = "users";