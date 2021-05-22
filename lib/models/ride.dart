import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'bike.dart';

class Ride {
  Bike bike;
  User user;
  LocationData checkoutLocation;
  LocationData returnLocation;
  DateTime checkoutTime;
  DateTime returnTime;
  var docID;
  num rating;

  Ride(
    Bike aBike,
    User aUser,
    LocationData coLocation,
    DateTime coTime,
  ) {
    this.bike = aBike;
    this.user = aUser;
    this.checkoutLocation = coLocation;
    this.checkoutTime = coTime;
  }

  Ride.fromMap(Map rideMap, var rideDocID, Bike thisBike) {
    this.bike = thisBike;
    this.docID = rideDocID;
    this.checkoutLocation = LocationData.fromMap({
      'latitude': rideMap['checkout_location'].latitude,
      'longitude': rideMap['checkout_location'].longitude,
    });
    Timestamp checkoutTimestamp = rideMap['checkout_time'];
    this.checkoutTime = new DateTime.fromMicrosecondsSinceEpoch(
        checkoutTimestamp.microsecondsSinceEpoch);
  }

  void printMe() {
    print('Bike: ${this.bike.bikeDescription}');
    print('User: ${this.user.email}');
    print('Checkout location: ${this.checkoutLocation}');
    print('Return location: ${this.returnLocation}');
    print('Checkout time: ${this.checkoutTime}');
    print('Return time: ${this.returnTime}');
  }
}
