import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bike.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';
import '../helpers/database_handler.dart';
import '../helpers/distance.dart';
import '../helpers/genericDialog.dart';

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
                  if (distance > 200) {
                    var cleanDistance =
                        double.parse(distance.toStringAsFixed(1));
                    genericDialog(context, 'Too far away', <Widget>[
                      Text('You are $cleanDistance meters from the bike'),
                      Text('You are too far away'),
                      Text(
                          'You must be within 200 meters of the bike to check out')
                    ]);
                  } else {
                    print('You are $distance meters from the bike');
                    // TODO: force the bikes to reload so that this bike now shows as checked out
                    print('Bike ID: ${thisBike.bikeID}');
                    print('Checking out a bike ${thisBike.bikeDescription}');
                    print(
                        'Currently located at ${currentLocation.latitude}, ${currentLocation.longitude}');
                    var thisUser = context.read<User>();
                    // create a new Ride instance, which will be temporarily assigned to the app's ride state
                    final Ride thisRide = Ride(
                        thisBike, thisUser, currentLocation, DateTime.now());
                    // tells Firestore that the bike is now checked out
                    updateBikeCheckout(thisBike);
                    // update app state so that it knows that a particular bike is checked out
                    var currentRide = context.read<CurrentRideState>();
                    currentRide.checkOutBike(thisRide);
                    // upload the ride info to storage
                    createRide(thisRide);

                    // save ride and bike to database
                    final databaseHandler = DatabaseHandler.getInstance();
                    await databaseHandler.saveRideState(
                        thisRide.docID, thisBike.bikeID);

                    // show the combination
                    genericDialog(context, 'Bike Combination', <Widget>[
                      Text('The combination is ${thisBike.lockCombination}'),
                      Text('Have a safe ride!')
                    ]);
                    // TODO: how to catch and handle race conditions where the bike is already checked out?
                  }
                },
                child: Text('Confirm Checkout')),
          ],
        )));
  }
}
