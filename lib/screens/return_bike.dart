import 'package:bikekollective/helpers/tasks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../models/bike.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../screens/sign_in.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';
import '../widgets/tag_manager.dart';
import '../widgets/text_widgets.dart';
import '../helpers/database_handler.dart';

class ReturnBike extends StatefulWidget {
  static const routeName = 'returnBike';
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  final formKey = GlobalKey<FormState>();
  // TODO: Show a "loading" icon while waiting for the return to complete
  LocationData currentLocation;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    var rideState = context.read<CurrentRideState>();
    final Ride currentRide = rideState.currentRide;
    final bikeToReturn = rideState.getCheckedOutBike();
    if (!rideState.onRide()) {
      Navigator.pop(context);
    }
    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(title: Text('Return bike')),
          body: SingleChildScrollView(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                paddedCenteredText(
                    'Complete the form below to return ${bikeToReturn.bikeName}'),
                paddedCenteredText('We hope you enjoyed the ride!'),
                paddedCenteredText(
                    'You can give the bike, update tags, and let us know about any issues'),
                Text('Return bike placeholder'),
                returnForm(currentRide, rideState, bikeToReturn),
              ]))));
    } else {
      return SignIn();
    }
  }

  Widget returnForm(
      Ride currentRide, CurrentRideState rideState, Bike bikeToReturn) {
    return Form(
        key: formKey,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(10),
                child: RatingBar(
                    allowHalfRating: true,
                    ratingWidget: RatingWidget(
                        full: Icon(Icons.star, color: Colors.amber),
                        half: Icon(Icons.star_half, color: Colors.amber),
                        empty: Icon(Icons.star_border, color: Colors.amber)),
                    onRatingUpdate: (rating) {
                      currentRide.rating = rating;
                    })),
            FractionallySizedBox(
                widthFactor: 0.9,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'If any, enter bike issue(s) here',
                      isDense: true,
                    ),
                    onSaved: (value) {
                      if (bikeToReturn.reportedIssues == null) {
                        bikeToReturn.reportedIssues = [];
                      }
                      if (value != '') {
                        return bikeToReturn.reportedIssues.add(value);
                      }
                    },
                  ),
                )),
            Padding(
              padding: EdgeInsets.all(10),
              child: editTags(context, bikeToReturn),
            ),
            ElevatedButton(
                onPressed: () async {
                  // stop all notifications
                  await Workmanager()
                      .initialize(callbackDispatcher, isInDebugMode: true);
                  await Workmanager().registerOneOffTask(
                      "cancelAllNotifications", "cancelAllNotifications");
                  currentLocation = await getLocation();
                  currentRide.returnLocation = currentLocation;
                  currentRide.returnTime = DateTime.now();
                  rideState.returnBike();
                  final databaseHandler = DatabaseHandler.getInstance();
                  databaseHandler.clearRideState();
                  bikeToReturn.location = GeoPoint(
                      currentLocation.latitude, currentLocation.longitude);
                  formKey.currentState.save();
                  updateBikeReturn(bikeToReturn, currentRide.rating);
                  updateRide(currentRide);

                  // stop all background processes since no need to monitor bike
                  Workmanager().cancelAll();
                  Navigator.pop(context);
                },
                child: Text('Confirm return'))
          ],
        ));
  }
}
