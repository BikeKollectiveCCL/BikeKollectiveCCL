import 'package:flutter/material.dart';
import '../models/bike.dart';
import 'checkout_bike.dart';
import 'single_bike_map.dart';

class BikeView extends StatelessWidget {
  // TODO: Should the bike be re-loaded from Firestore in case its state has changed since the list was loaded?
  static const routeName = 'viewBike';
  @override
  Widget build(BuildContext context) {
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
            Text('Report an issue button'),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(SingleBikeMap.routeName, arguments: thisBike);
                },
                child: Text('View bike on map')),
            if (!thisBike.isCheckedOut)
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(CheckoutBike.routeName, arguments: thisBike);
                  },
                  child: Text('Check out bike'))
          ],
        )));
  }
}
