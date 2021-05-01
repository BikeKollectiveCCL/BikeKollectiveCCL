import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

import 'bike.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Ride {
  Bike bike;
  User user;
  LocationData checkoutLocation;
  LocationData returnLocation;
  DateTime checkoutTime;
  DateTime returnTime;
  var docID;

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

  void printMe() {
    print('Bike: ${this.bike.bikeDescription}');
    print('User: ${this.user.email}');
    print('Checkout location: ${this.checkoutLocation}');
    print('Return location: ${this.returnLocation}');
    print('Checkout time: ${this.checkoutTime}');
    print('Return time: ${this.returnTime}');
  }
}
