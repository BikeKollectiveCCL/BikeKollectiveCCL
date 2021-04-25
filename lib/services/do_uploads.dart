// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../models/bike.dart';

void updateBikeCheckout(Bike thisBike) async {
  // TODO: how to catch and handle race conditions where the bike is already checked out?
  print('updating a bike');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({'checked_out': true})
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}

void updateBikeReturn(Bike thisBike) async {
  print('updating a bike');
  CollectionReference bikes = FirebaseFirestore.instance.collection('bikes');
  return bikes
      .doc(thisBike.bikeID)
      .update({'checked_out': false})
      .then((value) => print('Bike updated'))
      .catchError((error) => print('Failed to update bike: $error'));
}
