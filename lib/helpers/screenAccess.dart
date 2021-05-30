import 'package:bikekollective/services/authentication_service.dart';
import 'package:bikekollective/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';

var firebaseUser;
var appUsersSnapshots;
var currUser;

Map<String, dynamic> userHasScreenAccess(BuildContext context) {
  firebaseUser = context.watch<User>();
  appUsersSnapshots = context.watch<QuerySnapshot>();
  currUser = context.watch<AppUser>();
  if (firebaseUser != null &&
      appUsersSnapshots != null &&
      appUsersSnapshots.docs != null &&
      appUsersSnapshots.docs.length > 0) {
    currUser.setAuthId = firebaseUser.uid;
    if (currUser.isLockedOut == true) {
      final firebaseInstance = FirebaseService(FirebaseFirestore.instance);
      signOutUser(context, firebaseInstance, currUser.authId);
    }
    currUser.loadInfo(appUsersSnapshots.docs);
  }

  if (firebaseUser != null && currUser.isLockedOut != true) {
    if (currUser.hasSignedWaiver) {
      return formatResponse(true, '');
    } else {
      return formatResponse(false, 'AccidentWaiver');
    }
  } else {
    return formatResponse(false, 'SignIn');
  }
}

Map<String, dynamic> formatResponse(
    bool allowScreenAccess, String referToScreen) {
  return {
    "allowScreenAccess": allowScreenAccess,
    "referToScreen": referToScreen
  };
}

Future<void> signOutUser(
    BuildContext context, FirebaseService firebaseInstance, authId) async {
  await firebaseInstance.updateAppUserLoggedInStatus(false, authId);
  await context.read<AuthenticationService>().signOut();
}
