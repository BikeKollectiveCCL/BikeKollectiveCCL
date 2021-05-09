import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/bike.dart';

class BikeCombo extends StatelessWidget {
  static const routeName = 'bikeCombo';
  @override
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text('Bike combination')),
        body: Center(
            child: Column(children: [
          Text('The combination is:'),
          Text('${thisBike.lockCombination}'),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Dismiss'))
        ])));
  }
}
