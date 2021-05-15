import 'package:bikekollective/services/get_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import '../models/bike.dart';
import '../services/do_uploads.dart';
import '../helpers/distance.dart';

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
          children: [Text('Placeholder'), missingButton(context, thisBike)],
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
          distanceDialog(context);
        } else {
          updateBikeMissing(thisBike);
          confirmMissingDialog(context);
        }
      },
      child: Text('Report bike missing'));
}

void distanceDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Too far away'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('You are too far away from the bike\'s reported location'),
                Text('Please get closer and try again.')
              ],
            ),
          ),
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

void confirmMissingDialog(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bike reported'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [Text('The bike has been reported missing.')],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Acknowledge'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
