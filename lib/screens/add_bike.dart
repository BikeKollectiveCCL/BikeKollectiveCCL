import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/sign_in.dart';

class AddBike extends StatefulWidget {
  static const routeName = 'addBike';
  @override
  _AddBikeState createState() => _AddBikeState();
}

class _AddBikeState extends State<AddBike> {
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(title: Text('Add a new Bike')),
          body: Center(
              child: Column(children: [Text('Create bike placeholder')])));
    } else {
      return SignIn();
    }
  }
}
