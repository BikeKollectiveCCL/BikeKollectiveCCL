import 'package:flutter/widgets.dart';
import 'bike.dart';

class Ride extends ChangeNotifier {
  Bike _checkedOutBike = null;

  void checkOutBike(Bike someBike) {
    _checkedOutBike = someBike;
    notifyListeners();
  }

  Bike getCheckedOutBike() {
    return _checkedOutBike;
  }

  void returnBike() {
    _checkedOutBike = null;
    notifyListeners();
  }

  bool onRide() {
    if (_checkedOutBike != null) {
      return true;
    } else {
      return false;
    }
  }
}
