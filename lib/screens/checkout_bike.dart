import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bike.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../screens/bike_combo.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';
import '../helpers/distance.dart';

class CheckoutBike extends StatefulWidget {
  static const routeName = 'checkoutBike';
  @override
  _CheckoutBikeState createState() => _CheckoutBikeState();
}

class _CheckoutBikeState extends State<CheckoutBike> {
  // TODO: Show a "loading" icon while waiting for the checkout to complete
  LocationData currentLocation;
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
                  currentLocation = await getLocation();
                  double distance = getDistance(
                      thisBike.location.latitude,
                      thisBike.location.longitude,
                      currentLocation.latitude,
                      currentLocation.longitude);
                  print('You are $distance meters from the bike');
                  // TODO: force the bikes to reload so that this bike now shows as checked out
                  print('Bike ID: ${thisBike.bikeID}');
                  print('Checking out a bike ${thisBike.bikeDescription}');
                  print(
                      'Currently located at ${currentLocation.latitude}, ${currentLocation.longitude}');
                  var thisUser = context.read<User>();
                  // create a new Ride instance, which will be temporarily assigned to the app's ride state
                  final Ride thisRide =
                      Ride(thisBike, thisUser, currentLocation, DateTime.now());
                  // tells Firestore that the bike is now checked out
                  updateBikeCheckout(thisBike);
                  // update app state so that it knows that a particular bike is checked out
                  var currentRide = context.read<CurrentRideState>();
                  currentRide.checkOutBike(thisRide);
                  // upload the ride info to storage
                  createRide(thisRide);
                  // show the combination
                  Navigator.of(context)
                      .pushNamed(BikeCombo.routeName, arguments: thisBike);
                  // TODO: how to catch and handle race conditions where the bike is already checked out?
                },
                child: Text('Confirm Checkout')),
          ],
        )));
  }
}
