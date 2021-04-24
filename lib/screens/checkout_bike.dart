import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import '../models/bike.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';

class CheckoutBike extends StatefulWidget {
  static const routeName = 'checkoutBike';
  @override
  _CheckoutBikeState createState() => _CheckoutBikeState();
}

class _CheckoutBikeState extends State<CheckoutBike> {
  LocationData locationData;
  @override
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(title: Text('Bike Kollective')),
        body: Center(
            child: Column(
          children: [
            Text('Bike checkout placeholder'),
            ElevatedButton(
                onPressed: () async {
                  locationData = await getLocation();
                  // TODO: create a Ride object
                  // TODO: update app state so that the app knows that a bike is currently checked out
                  // TODO: send partial ride to Firestore
                  // TODO: force the bikes to reload so that this bike now shows as checked out
                  print('Bike ID: ${thisBike.bikeID}');
                  print('Checking out a bike ${thisBike.bikeDescription}');
                  print(
                      'Currently located at ${locationData.latitude}, ${locationData.longitude}');
                  // tells Firestore that the bike is now checked out
                  updateBike(thisBike);
                  // TODO: how to catch and handle race conditions where the bike is already checked out?
                },
                child: Text('Confirm Checkout')),
          ],
        )));
  }
}
