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
import '../widgets/tag_manager.dart';
import '../widgets/ratingDisplay.dart';

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
          body: ListView(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            children: [
              Column(children: [
                SizedBox(
                    height: 200,
                    child: Semantics(
                        label: 'bike image',
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: thisBike.url))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      thisBike.bikeType,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    if (thisBike.averageRating != null)
                      ratingDisplay(thisBike.averageRating, 30.0)
                    else
                      Text('No ratings yet.'),
                  ],
                ),
                Text(thisBike.bikeDescription),
                SizedBox(
                  height: 15.0,
                ),
                if (thisBike.missingReports >= 5)
                  Text('Warning: This bike is probably missing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ))
                else if (thisBike.missingReports > 0)
                  Text('Warning: This bike may be missing',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      )),
                SizedBox(
                  height: 3.0,
                ),
                if (!thisBike.isCheckedOut)
                  simpleButton(context, CheckoutBike.routeName,
                      'Check out bike', thisBike, Colors.green)
                else
                  Text('This bike is currently checked out. Check back soon!'),
                simpleButton(context, SingleBikeMap.routeName,
                    'View bike on map', thisBike, Colors.blue),
                simpleButton(context, ReportBike.routeName, 'Report bike',
                    thisBike, Colors.blue),
                SizedBox(
                  height: 10.0,
                ),
                if (thisBike.tags != null) loadTags(context, thisBike.tags),
                if (thisBike.reportedIssues != null &&
                    thisBike.reportedIssues.isNotEmpty)
                  loadIssues(context, thisBike.reportedIssues),
              ])
            ],
          ));
    } else {
      return SignIn();
    }
  }
}

Widget simpleButton(
    context, String route, String label, Bike bike, MaterialColor buttonColor) {
  return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route, arguments: bike);
      },
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
      ),
      child: Text(label));
}

Widget loadIssues(context, List issues) {
  String outputText = '';
  issues.forEach((element) {
    outputText = outputText + element + '; ';
  });
  if (outputText.endsWith('; ')) {
    outputText = outputText.substring(0, outputText.length - 2);
  }
  return Container(
    child: Column(
      children: [Text("Reported Issues"), Text(outputText)],
    ),
  );
}
