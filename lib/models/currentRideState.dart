import 'package:flutter/widgets.dart';
import 'bike.dart';
import 'ride.dart';
import '../helpers/database_handler.dart';
import '../services/do_uploads.dart';

class CurrentRideState extends ChangeNotifier {
  Ride currentRide;

  CurrentRideState() {
    this.init();
  }

  Future init() async {
    // see if there is a bike currently checked out locally
    final databaseHandler = DatabaseHandler.getInstance();
    List<Map> rideState = await databaseHandler.getRideState();
    if (rideState != null && rideState.length > 0) {
      String rideID = rideState[0]['ride_ID'];
      String bikeID = rideState[0]['bike_ID'];
      Map rideMap = await getRide(rideID);
      Map bikeMap = await getBike(bikeID);
      Bike thisBike = Bike.fromMap(bikeMap, bikeID);
      this.currentRide = Ride.fromMap(rideMap, rideID, thisBike);
    }
  }

  void checkOutBike(Ride newRide) {
    currentRide = newRide;
    notifyListeners();
  }

  Bike getCheckedOutBike() {
    if (currentRide != null) {
      return currentRide.bike;
    } else {
      return null;
    }
  }

  void returnBike() {
    currentRide = null;
    notifyListeners();
  }

  bool onRide() {
    if (currentRide != null) {
      return true;
    } else {
      return false;
    }
  }
}
