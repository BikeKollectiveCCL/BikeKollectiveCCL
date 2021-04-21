import 'package:flutter/material.dart';
import 'screens/bike_list.dart';
import 'screens/bike_map.dart';
import 'screens/add_bike.dart';
import 'screens/return_bike.dart';
import 'screens/single_bike_map.dart';
import 'screens/bike_view.dart';
import 'screens/checkout_bike.dart';

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
    CheckoutBike.routeName: (context) => CheckoutBike()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Bike Kollective', routes: routes);
  }
}
