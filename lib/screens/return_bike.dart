import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../screens/sign_in.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';
import '../widgets/tag_manager.dart';
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
          body: Center(
              child: Column(children: [
            Text('Return bike placeholder'),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    if (bikeToReturn != null) Text('${bikeToReturn.bikeName}'),
                    RatingBar(
                        allowHalfRating: true,
                        ratingWidget: RatingWidget(
                            full: Icon(Icons.star),
                            half: Icon(Icons.star_half),
                            empty: Icon(Icons.star_border)),
                        onRatingUpdate: (rating) {
                          currentRide.rating = rating;
                        }),
                    FractionallySizedBox(
                      widthFactor: 0.9,
                      child: TextFormField(
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'If any, enter bike issue(s) here',
                          isDense: true,
                        ),
                        onSaved: (value) {
                          if(bikeToReturn.reportedIssues == null) {
                            bikeToReturn.reportedIssues = [];
                          }
                          if(value != '') {
                            return bikeToReturn.reportedIssues.add(value);             
                          }
                        },
                      ),
                    ),
                    editTags(context, bikeToReturn),
                    ElevatedButton(
                        onPressed: () async {
                          Workmanager().cancelByUniqueName(
                              'eightHourCheck_${currentRide.docID}');
                          currentLocation = await getLocation();
                          currentRide.returnLocation = currentLocation;
                          currentRide.returnTime = DateTime.now();
                          rideState.returnBike();
                          final databaseHandler = DatabaseHandler.getInstance();
                          databaseHandler.clearRideState();
                          bikeToReturn.location = GeoPoint(
                              currentLocation.latitude,
                              currentLocation.longitude);
                          formKey.currentState.save();
                          updateBikeReturn(bikeToReturn, currentRide.rating);
                          updateRide(currentRide);
                          Navigator.pop(context);
                        },
                        child: Text('Confirm return'))
                  ],
                )),
          ])));
    } else {
      return SignIn();
    }
  }
}
