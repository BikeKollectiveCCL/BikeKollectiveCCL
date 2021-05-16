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
  int missingReports;

  Bike(
      {this.isCheckedOut = false,
      this.bikeDescription,
      this.location,
      this.lockCombination,
      this.averageRating,
      this.bikeType,
      this.url,
      this.tags});

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
    this.missingReports = bikeMap['missing_reports'];
  }

  void upload() {
    this.bikeType = this.bikeType.toLowerCase();
    var temp = this.bikeType[0].toUpperCase();
    temp = temp + this.bikeType.substring(1);
    this.bikeType = temp;

    FirebaseFirestore.instance.collection('bikes').add({
      'checked_out': this.isCheckedOut,
      'description': this.bikeDescription,
      'location': this.location,
      'lock_combination': this.lockCombination,
      'rating': this.averageRating,
      'type': this.bikeType,
      'url': this.url,
      'count_ratings': 0,
      'tags': this.tags,
      'missing_reports': 0
    });
  }
}
