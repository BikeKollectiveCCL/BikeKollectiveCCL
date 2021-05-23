import 'package:bikekollective/services/get_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import '../models/bike.dart';
import '../services/do_uploads.dart';
import '../helpers/distance.dart';
import '../helpers/genericDialog.dart';
import '../screens/report_bike_issue.dart';

class ReportBike extends StatefulWidget {
  static const routeName = 'reportBike';
  @override
  _ReportBikeState createState() => _ReportBikeState();
}

class _ReportBikeState extends State<ReportBike> {
  final formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text('Report bike')),
        body: Center(
            child: Column(
          children: [
            Text('Placeholder'),
            missingButton(context, thisBike),
            issueButton(context, thisBike)
          ],
        )));
  }
}

Widget missingButton(context, Bike thisBike) {
  LocationData currentLocation;
  return ElevatedButton(
      onPressed: () async {
        currentLocation = await getLocation();
        double distance = getDistance(
            thisBike.location.latitude,
            thisBike.location.longitude,
            currentLocation.latitude,
            currentLocation.longitude);
        if (distance > 200) {
          genericDialog(
              context,
              'Too far away',
              <Widget>[
                Text('You are too far away from the bike\'s reported location'),
                Text('Please get closer and try again.')
              ],
              1);
        } else {
          updateBikeMissing(thisBike);
          genericDialog(context, 'Bike reported',
              <Widget>[Text('The bike has been reported missing.')], 1);
        }
      },
      child: Text('Report bike missing'));
}

Widget issueButton(context, Bike thisBike) {
  LocationData currentLocation;
  return ElevatedButton(
      onPressed: () async {
        currentLocation = await getLocation();
        double distance = getDistance(
            thisBike.location.latitude,
            thisBike.location.longitude,
            currentLocation.latitude,
            currentLocation.longitude);
        if (distance > 200) {
          genericDialog(
              context,
              'Too far away',
              <Widget>[
                Text('You are too far away from the bike\'s reported location'),
                Text('Please get closer and try again.')
              ],
              1);
        } else {
          Navigator.of(context)
              .pushNamed(ReportBikeIssue.routeName, arguments: thisBike);
        }
      },
      child: Text('Report an issue with the bike'));
}
