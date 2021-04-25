import 'package:bikekollective/screens/sign_in.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/bike_list.dart';
import 'screens/bike_map.dart';
import 'screens/add_bike.dart';
import 'screens/return_bike.dart';
import 'screens/single_bike_map.dart';
import 'screens/bike_view.dart';
import 'screens/checkout_bike.dart';
import 'screens/sign_in.dart';
import 'screens/sign_up.dart';
import 'wrappers/authentication_wrapper.dart';
import 'models/currentRideState.dart';

class BikeKollective extends StatefulWidget {
  @override
  _BikeKollectiveState createState() => _BikeKollectiveState();
}

class _BikeKollectiveState extends State<BikeKollective> {
  // static final routes = {BikeList.routeName: (context) => BikeList()};
  static final routes = {
    BikeMap.routeName: (context) => BikeMap(),
    BikeView.routeName: (context) => BikeView(),
    BikeList.routeName: (context) => BikeList(),
    AddBike.routeName: (context) => AddBike(),
    ReturnBike.routeName: (context) => ReturnBike(),
    SingleBikeMap.routeName: (context) => SingleBikeMap(),
    CheckoutBike.routeName: (context) => CheckoutBike(),
    SignIn.routeName: (context) => SignIn(),
    SignUp.routeName: (context) => SignUp()
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          ListenableProvider<CurrentRideState>(
            create: (context) => CurrentRideState(),
          ),
          StreamProvider(
              initialData: null,
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges),
        ],
        child: MaterialApp(
          title: 'Bike Kollective',
          debugShowCheckedModeBanner: false,
          routes: routes,
        ));
  }
}
