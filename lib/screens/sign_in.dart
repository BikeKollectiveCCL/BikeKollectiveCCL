import 'package:bikekollective/screens/bike_map.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  static const routeName = 'signInPage';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // void showInSnackBar(String value) {
  //   _scaffoldKey.currentState
  //       .showSnackBar(new SnackBar(content: new Text(value)));
  // }
  @override
  void initState() {
    // Call your async method here
    //_fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pedal_bike,
                  color: Colors.blue,
                  size: 84,
                ),
                SizedBox(
                  height: 12,
                ),
                Text("Bike Kollective",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        fontStyle: FontStyle.normal,
                        color: Colors.blue)),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                PasswordField(
                  controller: passwordController,
                  //color: Colors.blue,
                  hasFloatingPlaceholder: true,
                  autoFocus: false,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(width: 2, color: Colors.grey)),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Map response = await context
                          .read<AuthenticationService>()
                          .signIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                      final snackBar = SnackBar(
                        content: Text(response["message"]),
                        action: SnackBarAction(
                          label: response["message"] ==
                                  "Wrong password provided for that user."
                              ? "Reset password via email"
                              : '',
                          onPressed: () async {
                            // Some code if needed
                            if (response["message"] ==
                                "Wrong password provided for that user.") {
                              await context
                                  .read<AuthenticationService>()
                                  .resetPassword(
                                      email: emailController.text.trim());
                            }
                          },
                        ),
                      );
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        if (snackBar != null) {
                          var currentScaffold = _scaffoldKey.currentState;
                          //currentScaffold.hideCurrentSnackBar();
                          //currentScaffold.showSnackBar(snackBar);
                          //ScaffoldMessengerState.hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        if (response["success"]) {
                          //go to root '/'
                          Navigator.of(context).pushNamed(BikeMap.routeName);
                        }
                      });
                    },
                    child: Text("Sign in")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignUp.routeName);
                    },
                    child: Text("Sign up"))
              ],
            ),
          ),
        ));
  }
}
