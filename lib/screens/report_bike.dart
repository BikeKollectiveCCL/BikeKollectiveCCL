import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

class ReportBike extends StatefulWidget {
  static const routeName = 'reportBike';
  @override
  _ReportBikeState createState() => _ReportBikeState();
}

class _ReportBikeState extends State<ReportBike> {
  final formKey = GlobalKey<FormState>();
  LocationData locationData;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Report bike')),
        body: Center(
            child: Column(
          children: [
            Text('Placeholder'),
          ],
        )));
  }
}
