import 'package:cloud_firestore/cloud_firestore.dart';

class Bike {
  String bikeName;
  double latitude;
  double longitude;
  GeoPoint location;
  double averageRating;
  int countRatings;
  String bikeType;
  String bikeDescription;
  String lockCombination;
  bool isCheckedOut;
  var bikeID;
  String url;
  Map tags;

  Bike.fromMap(Map bikeMap, var bikeDocID) {
    this.bikeName = bikeMap['description'];
    this.location = bikeMap['location'];
    if (bikeMap['rating'] == null) {
      this.averageRating = null;
    } else {
      this.averageRating = bikeMap['rating'] + 0.0;
    }
    this.bikeType = bikeMap['type'];
    this.bikeDescription = bikeMap['description'];
    this.lockCombination = bikeMap['lock_combination'];
    this.isCheckedOut = bikeMap['checked_out'];
    this.bikeID = bikeDocID;
    this.url = bikeMap['url'];
    this.countRatings = bikeMap['count_ratings'];
    this.tags = bikeMap['tags'];
  }
}
