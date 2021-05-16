import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void genericDialog(context, String title, List bodyText) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: ListBody(children: bodyText)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Understood'))
          ],
        );
      });
}
