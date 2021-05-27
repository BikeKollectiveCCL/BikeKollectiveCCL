import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget paddedCenteredText(String messageText) {
  return Padding(
      padding: EdgeInsets.all(15),
      child: Text(messageText, textAlign: TextAlign.center));
}

Widget headerText(String messageText, [double size]) {
  return Padding(
      padding: EdgeInsets.all(5),
      child: Text(messageText,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: size ?? 10)));
}
