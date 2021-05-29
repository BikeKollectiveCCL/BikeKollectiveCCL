import 'package:cloud_firestore/cloud_firestore.dart';
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

void updateBikeMissing(Bike thisBike) async {
  if (thisBike.missingReports != null) {
    thisBike.missingReports += 1;
  } else {
    thisBike.missingReports = 1;
  }
  print('reporting bike as missing');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({'missing_reports': thisBike.missingReports})
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
    newAvg = thisBike.averageRating;
    newCount = thisBike.countRatings;
  }

  // tell Firestore that the bike is no longer checked out
  print('updating a bike');
  print('${thisBike.tags}');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({
        'checked_out': false,
        'count_ratings': newCount,
        'rating': newAvg,
        'location': thisBike.location,
        'tags': thisBike.tags,
        'reported_issues': thisBike.reportedIssues
      })
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}

void updateBikeIssues(Bike thisBike) async {
  // update a bike's reported issues
  print('updating a bike\'s issues');
  print('${thisBike.tags}');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({'reported_issues': thisBike.reportedIssues})
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

Future<Map> getRide(String rideID) {
  // get a single ride by document ID
  return FirebaseFirestore.instance
      .collection('rides')
      .doc(rideID)
      .get()
      .then((DocumentSnapshot thisRide) {
    return thisRide.data();
  });
}

Future<Map> getBike(String bikeID) {
  // get a single bike by document ID
  return FirebaseFirestore.instance
      .collection('bikes')
      .doc(bikeID)
      .get()
      .then((DocumentSnapshot thisRide) {
    return thisRide.data();
  });
}
