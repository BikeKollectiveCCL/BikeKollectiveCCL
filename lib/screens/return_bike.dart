import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReturnBike extends StatefulWidget {
  static const routeName = 'returnBike';
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Return bike')),
        body: Center(
            child: Column(children: [
          Text('Return bike placeholder'),
        ])));
  }
}
