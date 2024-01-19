import 'package:flutter/material.dart';

import 'constants.dart';

List getNavBarItems(
    bool isHomeSelected,
    bool isChatSelected,
    bool isProfileSelected) {
  return [
    getBottomMenuItem(
      'Home',
      Icons.home_rounded,
      Icons.home_outlined,
      isHomeSelected,
    ),
    getBottomMenuItem(
      'Chat',
      Icons.chat_bubble_rounded,
      Icons.chat_bubble_outline,
      isChatSelected,
    ),
    getBottomMenuItem(
      'Profile',
      Icons.person,
      Icons.perm_identity_outlined,
      isProfileSelected,
    )
  ];
}
