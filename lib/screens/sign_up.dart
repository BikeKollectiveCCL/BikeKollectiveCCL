import 'package:bikekollective/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  static const routeName = 'signUp';
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
          SizedBox(
            height: 50,
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
            hasFloatingPlaceholder: true,
            autoFocus: false,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(width: 2, color: Colors.grey)),
            maxLength: 32,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () async {
              Map response = await context.read<AuthenticationService>().signUp(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim());
              final snackBar = SnackBar(
                content: Text(response["message"]),
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: () {
                    // Some code if needed
                  },
                ),
              );
              // Find the ScaffoldMessenger in the widget tree
              // and use it to show a SnackBar.
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (response["success"]) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Sign up'),
          ),
        ],
      ),
    ));
  }
}
