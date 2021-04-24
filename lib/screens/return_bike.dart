import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ride.dart';
import '../screens/sign_in.dart';
import '../services/get_location.dart';
import '../services/do_uploads.dart';

class ReturnBike extends StatefulWidget {
  static const routeName = 'returnBike';
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  // TODO: Show a "loading" icon while waiting for the return to complete
  LocationData locationData;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    var ride = context.read<Ride>();
    final bikeToReturn = ride.getCheckedOutBike();
    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(title: Text('Return bike')),
          body: Center(
              child: Column(children: [
            Text('Return bike placeholder'),
            if (bikeToReturn != null) Text('${bikeToReturn.bikeName}'),
            if (bikeToReturn != null)
              ElevatedButton(
                  onPressed: () async {
                    locationData = await getLocation();
                    ride.returnBike();
                    updateBikeReturn(bikeToReturn);
                  },
                  child: Text('Confirm return'))
          ])));
    } else {
      return SignIn();
    }
  }
}
