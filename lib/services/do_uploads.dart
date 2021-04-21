// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../models/bike.dart';

void updateBike(Bike thisBike) async {
  // TODO: how to catch and handle race conditions where the bike is already checked out?
  print('updating a bike');
  CollectionReference bikes = Firestore.instance.collection('bikes');
  return bikes
      .document(thisBike.bikeID)
      .updateData({'checked_out': true})
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}
