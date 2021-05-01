import 'package:flutter/widgets.dart';
import 'bike.dart';
import 'ride.dart';

class CurrentRideState extends ChangeNotifier {
  Ride currentRide;

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
