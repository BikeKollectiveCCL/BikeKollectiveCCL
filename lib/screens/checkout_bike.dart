import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../models/bike.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';
import '../helpers/database_handler.dart';
import '../helpers/distance.dart';
import '../helpers/genericDialog.dart';
import '../helpers/tasks.dart';
import '../widgets/text_widgets.dart';

// after this # of min elapsed, app will start bugging user
final int ALLOWED_RIDE_TIME_MIN = 8 * 60;

// after this # of min elapsed, account will get locked out indefintely
final int ACCOUNT_LOCKOUT_THRESHOLD_MIN = 24 * 60;

// after ALLOWED_RIDE_TIME_MIN elapsed, and user still hs bike, remind him per this interval
final int REMIND_USER_RETURN_BIKE_INTERVAL_MIN = 60;

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            paddedCenteredText('Tap the button below to check out the bike'),
            paddedCenteredText(
                'You are checking out a ${thisBike.bikeType} bike'),
            paddedCenteredText('Please return the bike within 8 hours'),
            checkoutButton(thisBike),
          ],
        )));
  }

  Widget checkoutButton(Bike thisBike) {
    return ElevatedButton(
        onPressed: () async {
          currentLocation = await getLocation();
          double distance = getDistance(
              thisBike.location.latitude,
              thisBike.location.longitude,
              currentLocation.latitude,
              currentLocation.longitude);
          if (distance > 200) {
            var cleanDistance = double.parse(distance.toStringAsFixed(1));
            genericDialog(
                context,
                'Too far away',
                <Widget>[
                  Text('You are $cleanDistance meters from the bike'),
                  Text('You are too far away'),
                  Text('You must be within 200 meters of the bike to check out')
                ],
                1);
          } else {
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

            // save ride and bike to database
            final databaseHandler = DatabaseHandler.getInstance();
            await databaseHandler.saveRideState(
                thisRide.docID, thisBike.bikeID);

            // schedule task
            await Workmanager()
                .initialize(callbackDispatcher, isInDebugMode: false);
            await Workmanager().registerOneOffTask(
              'eightHourCheck_${thisRide.docID}',
              'eightHourCheck',
              initialDelay: Duration(minutes: ALLOWED_RIDE_TIME_MIN),
              inputData: {
                "rideID": thisRide.docID,
                "user": thisRide.user.email,
                "userID": thisUser.uid,
                "bikeID": thisRide.bike.bikeID,
                "checkoutTime_epoch_ms":
                    thisRide.checkoutTime.millisecondsSinceEpoch,
                "ALLOWED_RIDE_TIME_MIN": ALLOWED_RIDE_TIME_MIN,
                "ACCOUNT_LOCKOUT_THRESHOLD_MIN": ACCOUNT_LOCKOUT_THRESHOLD_MIN,
                "REMIND_USER_RETURN_BIKE_INTERVAL_MIN":
                    REMIND_USER_RETURN_BIKE_INTERVAL_MIN
              },
            );

            // show the combination
            genericDialog(
                context,
                'Bike Combination',
                <Widget>[
                  Text('The combination is ${thisBike.lockCombination}'),
                  Text('Have a safe ride!')
                ],
                2);
            // TODO: how to catch and handle race conditions where the bike is already checked out?
          }
        },
        child: Text('Confirm Checkout'));
  }
}
