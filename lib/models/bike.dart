class Bike {
  String bikeName;
  double latitude;
  double longitude;
  num averageRating;
  String bikeType;
  String bikeDescription;
  String lockCombination;
  bool isCheckedOut;
  // List bikeTags;
  // List bikeImages;
  // List bikeIssues;

  Bike.fromMap(Map bikeMap) {
    this.bikeName = bikeMap['description'];
    this.latitude = bikeMap['location'].latitude;
    this.longitude = bikeMap['location'].longitude;
    this.averageRating = bikeMap['rating'];
    this.bikeType = bikeMap['type'];
    this.bikeDescription = bikeMap['description'];
    this.lockCombination = bikeMap['combination'];
    this.isCheckedOut = bikeMap['checked_out'];
  }
}
