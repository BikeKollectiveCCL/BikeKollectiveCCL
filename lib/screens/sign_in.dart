import 'package:bikekollective/screens/bike_map.dart';
import 'package:bikekollective/services/authentication_service.dart';
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
        body: Column(
      children: [
        SizedBox(
          height: 50,
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: "Password"),
        ),
        ElevatedButton(
            onPressed: () async {
              Map response = await context.read<AuthenticationService>().signIn(
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
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    ));
  }
}
