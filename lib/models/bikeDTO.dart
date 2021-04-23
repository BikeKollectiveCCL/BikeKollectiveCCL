import 'package:cloud_firestore/cloud_firestore.dart';

class BikeDTO {
  bool checked_out;
  String description;
  GeoPoint location;
  String lock_combination;
  double rating;
  String type;
  String url;

  BikeDTO({
    this.checked_out = false, 
    this.description, 
    this.location, 
    this.lock_combination,
    this.rating,
    this.type,
    this.url});

  void upload() {
    FirebaseFirestore.instance.collection('bikes').add({
      'checked_out': this.checked_out,
      'description': this.description,
      'location': this.location,
      'lock_combination': this.lock_combination,
      'rating': this.rating,
      'type':this.type,
      'url':this.url
    });
  }
}