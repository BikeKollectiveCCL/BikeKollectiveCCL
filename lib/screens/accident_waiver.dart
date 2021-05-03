import 'package:bikekollective/models/app_user.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:bikekollective/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/sign_in.dart';
import 'bike_map.dart';

class AccidentWaiver extends StatefulWidget {
  static const routeName = 'accidentWaiver';
  @override
  _AccidentWaiverState createState() => _AccidentWaiverState();
}

class _AccidentWaiverState extends State<AccidentWaiver> {
  String waiverText = '';

  @override
  void initState() {
    super.initState();
    getWaiverText();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    final currUser = context.watch<AppUser>();
    if (firebaseUser != null) {
      return SafeArea(
          child: new Scaffold(
              appBar: new AppBar(
                  centerTitle: true,
                  title: const Text('Accident Waiver'),
                  actions: [
                    GestureDetector(
                        onTap: () {
                          // update user signed_waiver here via firebase service
                          context
                              .read<FirebaseService>()
                              .updateAppUserSignedWaiverStatus(
                                  true, currUser.authId);
                          Navigator.of(context).pushNamed(BikeMap.routeName);
                        },
                        child: Center(
                          child: Row(
                            children: [
                              Text('AGREE',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        )),
                  ],
                  leading: GestureDetector(
                    onTap: () {
                      // user rejected waiver, sign user off and return to log in page
                      final snackBar = SnackBar(
                        content: const Text("Please accept waiver to use app"),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Some code if needed
                          },
                        ),
                      );
                      context
                          .read<FirebaseService>()
                          .updateAppUserSignedWaiverStatus(
                              false, currUser.authId);
                      context
                          .read<FirebaseService>()
                          .updateAppUserLoggedInStatus(false, currUser.authId);
                      context.read<AuthenticationService>().signOut();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pushNamed(SignIn.routeName);
                    },
                    child: Icon(Icons.cancel_sharp,
                        color: Colors.white, size: 28.0),
                  )),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (waiverText),
                  ),
                ),
              )));
    } else {
      return SignIn();
    }
  }

  Future<void> getWaiverText() async {
    String result;
    result = await rootBundle.loadString("assets/text/waiver.txt");
    setState(() {
      waiverText = result;
    });
  }
}
