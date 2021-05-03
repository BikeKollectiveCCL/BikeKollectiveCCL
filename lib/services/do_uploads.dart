import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/bike.dart';
import '../models/ride.dart';

void updateBikeCheckout(Bike thisBike) async {
  // tell Firestore that the bike is checked out
  // TODO: how to catch and handle race conditions where the bike is already checked out?
  print('updating a bike');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({'checked_out': true})
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}

void updateBikeReturn(Bike thisBike, double rating) async {
  double newAvg;
  int newCount;
  if (rating != null) {
    if (thisBike.averageRating == null) {
      newAvg = rating;
    } else {
      newAvg = ((thisBike.averageRating * thisBike.countRatings) + rating) /
          (thisBike.countRatings + 1);
    }
    newCount = thisBike.countRatings + 1;
  } else {
    newAvg = null;
    newCount = thisBike.countRatings;
  }

  // tell Firestore that the bike is no longer checked out
  print('updating a bike');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update(
          {'checked_out': false, 'count_ratings': newCount, 'rating': newAvg})
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}

void createRide(Ride thisRide) async {
  // create a Ride record in Firestore
  DocumentReference fsRide =
      FirebaseFirestore.instance.collection('rides').doc();
  thisRide.docID = fsRide.id;

  fsRide.set({
    'bike': FirebaseFirestore.instance
        .collection('bikes')
        .doc(thisRide.bike.bikeID),
    'user': thisRide.user.email,
    'checkout_time': Timestamp.fromDate(thisRide.checkoutTime),
    'checkout_location': GeoPoint(
        thisRide.checkoutLocation.latitude, thisRide.checkoutLocation.longitude)
  });
}

void updateRide(Ride thisRide) async {
  // complete the Ride record in Firestore
  FirebaseFirestore.instance.collection('rides').doc(thisRide.docID).update({
    'return_time': Timestamp.fromDate(thisRide.returnTime),
    'return_location': GeoPoint(
        thisRide.returnLocation.latitude, thisRide.returnLocation.longitude),
    'rating': thisRide.rating
  });
}
