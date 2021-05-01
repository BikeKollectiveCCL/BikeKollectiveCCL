import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/bike.dart';
import 'checkout_bike.dart';
import 'single_bike_map.dart';
import '../screens/sign_in.dart';

class BikeView extends StatelessWidget {
  // TODO: Should the bike be re-loaded from Firestore in case its state has changed since the list was loaded?
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
              if (thisBike.averageRating != null)
                RatingBarIndicator(
                  rating: thisBike.averageRating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 40.0,
                )
              else
                Text('This bike has no ratings'),
              if (thisBike.isCheckedOut) Text('currently checked out'),
              if (!thisBike.isCheckedOut) Text('this bike is available'),
              Text(thisBike.bikeDescription),
              if (!thisBike.isCheckedOut) Text('Checkout button'),
              Text('Report an issue button'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SingleBikeMap.routeName,
                        arguments: thisBike);
                  },
                  child: Text('View bike on map')),
              if (!thisBike.isCheckedOut)
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CheckoutBike.routeName,
                          arguments: thisBike);
                    },
                    child: Text('Check out bike'))
            ],
          )));
    } else {
      return SignIn();
    }
  }
}
