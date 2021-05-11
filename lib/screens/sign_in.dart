import 'package:bikekollective/screens/bike_map.dart';
import 'package:bikekollective/services/authentication_service.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_up.dart';

class SignIn extends StatelessWidget {
  static const routeName = 'signInPage';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                    label: '',
                    onPressed: () {
                      // Some code if needed
                    },
                  ),
                );
                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                if (snackBar != null) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                if (response["success"]) {
                  //go to root '/'
                  Navigator.of(context).pushNamed(BikeMap.routeName);
                }
              },
              child: Text("Sign in")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SignUp.routeName);
              },
              child: Text("Sign up"))
        ],
      ),
    ));
  }
}
