class Bike {
  String bikeName;
  double latitude;
  double longitude;
  num averageRating;
  String bikeType;
  String bikeDescription;
  String lockCombination;
  bool isCheckedOut;
  var bikeID;
  String url;
  // List bikeTags;
  // List bikeImages;
  // List bikeIssues;

  Bike.fromMap(Map bikeMap, var bikeDocID) {
    this.bikeName = bikeMap['description'];
    this.latitude = bikeMap['location'].latitude;
    this.longitude = bikeMap['location'].longitude;
    this.averageRating = bikeMap['rating'];
    this.bikeType = bikeMap['type'];
    this.bikeDescription = bikeMap['description'];
    this.lockCombination = bikeMap['combination'];
    this.isCheckedOut = bikeMap['checked_out'];
    this.bikeID = bikeDocID;
    this.url = bikeMap['url'];
  }
}
