import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bike.dart';
import '../widgets/navdrawer.dart';
import '../screens/sign_in.dart';

class SingleBikeMap extends StatefulWidget {
  static const routeName = 'singleBikeMap';
  @override
  _SingleBikeMap createState() => _SingleBikeMap();
}

class _SingleBikeMap extends State<SingleBikeMap> {
  Widget build(BuildContext context) {
    final Bike thisBike = ModalRoute.of(context).settings.arguments;
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text('${thisBike.bikeName}'),
            backgroundColor: Colors.green[700],
          ),
          body: Column(
            children: [Text('Bike Map placeholder')],
          ));
    } else {
      return SignIn();
    }
  }
}
