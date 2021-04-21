import 'package:flutter/material.dart';
import '../models/bike.dart';
import '../widgets/navdrawer.dart';

class SingleBikeMap extends StatefulWidget {
  static const routeName = 'singleBikeMap';
  @override
  _SingleBikeMap createState() => _SingleBikeMap();
}

class _SingleBikeMap extends State<SingleBikeMap> {
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('${thisBike.bikeName}'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: [Text('Bike Map placeholder')],
        ));
  }
}
