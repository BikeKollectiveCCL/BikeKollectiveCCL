import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/sign_in.dart';

class ReturnBike extends StatefulWidget {
  static const routeName = 'returnBike';
  @override
  _ReturnBikeState createState() => _ReturnBikeState();
}

class _ReturnBikeState extends State<ReturnBike> {
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(title: Text('Return bike')),
          body: Center(
              child: Column(children: [
            Text('Return bike placeholder'),
          ])));
    } else {
      return SignIn();
    }
  }
}
