import 'package:provider/provider.dart';
import 'package:bikekollective/screens/sign_in.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../screens/bike_list.dart';
import '../screens/bike_map.dart';
import '../screens/add_bike.dart';
import '../screens/return_bike.dart';
import '../screens/sign_in.dart';
import '../models/currentRideState.dart';

Widget navDrawer(BuildContext context) {
  return Consumer<CurrentRideState>(
      builder: (context, ride, child) => Drawer(
              child: ListView(
            children: <Widget>[
              ListTile(
                  title: Text('Bike List'),
                  onTap: () {
                    // Navigator.of(context).pushNamed(BikeList.routeName);
                    Navigator.pushReplacementNamed(context, BikeList.routeName);
                  }),
              ListTile(
                  title: Text('Bike Map'),
                  onTap: () {
                    // Navigator.of(context).pushNamed(BikeMap.routeName);
                    Navigator.pushReplacementNamed(context, BikeMap.routeName);
                  }),
              ListTile(
                  title: Text('Add Bike'),
                  onTap: () {
                    Navigator.of(context).pushNamed(AddBike.routeName);
                  }),
              if (ride.onRide())
                ListTile(
                    title: Text('Return Bike'),
                    onTap: () {
                      Navigator.of(context).pushNamed(ReturnBike.routeName);
                    }),
              ListTile(
                  title: Text('Sign Out'),
                  onTap: () {
                    context.read<AuthenticationService>().signOut();
                    Navigator.of(context).pushNamed(SignIn.routeName);
                  }),
            ],
          )));
}
