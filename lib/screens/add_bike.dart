import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddBike extends StatefulWidget {
  static const routeName = 'addBike';
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add a new Bike')),
        body:
            Center(child: Column(children: [Text('Create bike placeholder')])));
  }
}
