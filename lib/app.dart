import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikekollective/models/app_user.dart';
import 'package:bikekollective/screens/sign_in.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:bikekollective/services/firebase_service.dart';
import 'models/currentRideState.dart';
import 'screens/bike_list.dart';
import 'screens/bike_map.dart';
import 'screens/add_bike.dart';
import 'screens/return_bike.dart';
import 'screens/single_bike_map.dart';
import 'screens/bike_view.dart';
import 'screens/checkout_bike.dart';
import 'screens/sign_in.dart';
import 'screens/sign_up.dart';
import 'screens/report_bike.dart';

class BikeKollective extends StatefulWidget {
  @override
  _BikeKollectiveState createState() => _BikeKollectiveState();
}

class _BikeKollectiveState extends State<BikeKollective> {
  static final routes = {
    BikeMap.routeName: (context) => BikeMap(),
    BikeView.routeName: (context) => BikeView(),
    BikeList.routeName: (context) => BikeList(),
    AddBike.routeName: (context) => AddBike(),
    ReturnBike.routeName: (context) => ReturnBike(),
    SingleBikeMap.routeName: (context) => SingleBikeMap(),
    CheckoutBike.routeName: (context) => CheckoutBike(),
    ReportBike.routeName: (context) => ReportBike(),
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
          Provider<FirebaseService>(
            create: (context) => FirebaseService(FirebaseFirestore.instance),
          ),
          ListenableProvider<AppUser>(
            create: (context) => AppUser(),
          ),
          StreamProvider(
              initialData: null,
              create: (context) =>
                  context.read<FirebaseService>().getAppUserCollectionStream()),
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
