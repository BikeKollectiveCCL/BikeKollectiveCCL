import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:transparent_image/transparent_image.dart';
import '../models/bike.dart';
import 'checkout_bike.dart';
import 'single_bike_map.dart';
import '../screens/sign_in.dart';
import '../screens/report_bike.dart';

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
              SizedBox(
                  height: 300,
                  child: Semantics(
                      label: 'bike image',
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: thisBike.url))),
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
              if (thisBike.isCheckedOut)
                Text('currently checked out')
              else
                Text('this bike is available'),
              Text(thisBike.bikeDescription),
              if (!thisBike.isCheckedOut) Text('Checkout button'),
              simpleButton(
                  context, ReportBike.routeName, 'Report bike', thisBike),
              simpleButton(context, SingleBikeMap.routeName, 'View bike on map',
                  thisBike),
              if (!thisBike.isCheckedOut)
                simpleButton(
                    context, CheckoutBike.routeName, 'Check out bike', thisBike)
            ],
          )));
    } else {
      return SignIn();
    }
  }
}

Widget simpleButton(context, String route, String label, Bike bike) {
  return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route, arguments: bike);
      },
      child: Text(label));
}
