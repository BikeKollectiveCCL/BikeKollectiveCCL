import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bike.dart';
import '../screens/sign_in.dart';

class BikeView extends StatelessWidget {
  static const routeName = 'viewBike';
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      final Bike thisBike = ModalRoute.of(context).settings.arguments;
      return Scaffold(
          appBar: AppBar(title: Text('Bike Kollective')),
          body: Center(
              child: Column(
            children: [
              Text('Placeholder bike page for ${thisBike.bikeName}'),
              Text('Image will go here'),
              Text('Rating will go here'),
              if (thisBike.isCheckedOut) Text('currently checked out'),
              if (!thisBike.isCheckedOut) Text('this bike is available'),
              Text(thisBike.bikeDescription),
              Text('Map or map link'),
              if (!thisBike.isCheckedOut) Text('Checkout button'),
              Text('Report an issue button'),
            ],
          )));
    } else {
      return SignIn();
    }
  }
}
