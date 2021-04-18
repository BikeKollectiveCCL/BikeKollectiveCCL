import 'package:flutter/material.dart';
import '../widgets/navdrawer.dart';

class BikeMap extends StatefulWidget {
  static const routeName = '/';
  @override
  _BikeMapState createState() => _BikeMapState();
}

class _BikeMapState extends State<BikeMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bike Map'),
          backgroundColor: Colors.green[700],
        ),
        drawer: navDrawer(context),
        body: Column(
          children: [
            Text('Bike map placeholder'),
          ],
        ));
  }
}
