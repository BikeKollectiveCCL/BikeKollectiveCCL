import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void genericDialog(context, String title, List bodyText, int pops) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: ListBody(children: bodyText)),
          actions: [
            TextButton(
                onPressed: () {
                  for (var i = 0; i <= pops; i++) {
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Understood'))
          ],
        );
      });
}
