import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/currentRideState.dart';
import '../models/ride.dart';
import '../screens/sign_in.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';

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
                    ElevatedButton(
                        onPressed: () async {
                          currentLocation = await getLocation();
                          currentRide.returnLocation = currentLocation;
                          currentRide.returnTime = DateTime.now();
                          rideState.returnBike();
                          bikeToReturn.location = GeoPoint(
                              currentLocation.latitude,
                              currentLocation.longitude);
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
