import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bikekollective/app.dart';
import 'helpers/database_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DatabaseHandler.initialize();
  runApp(BikeKollective());
}
