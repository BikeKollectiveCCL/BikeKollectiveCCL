import 'package:bikekollective/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AppUser extends ChangeNotifier {
  final firebaseInstance = FirebaseService(FirebaseFirestore.instance);
  String _authId;
  bool loggedIn;
  bool signedWaiver;
  bool bikeCheckedOut;

  AppUser() {
    this._authId = null;
    this.loggedIn = false;
    this.signedWaiver = false;
    this.bikeCheckedOut = false;
  }

  AppUser.fromMap(Map appUserMap) {
    this._authId = appUserMap['auth_id'];
    this.loggedIn = appUserMap['logged_in'];
    this.signedWaiver = appUserMap['signed_waiver'];
    this.bikeCheckedOut = appUserMap['logged_in'];
  }

  Map<String, dynamic> toJson() => {
        "logged_in": this.loggedIn,
        "signed_waiver": this.signedWaiver,
        "biked_checked_out": this.bikeCheckedOut
      };

  void upload() async {
    bool result = await isInDb();
    // if user not in DB then create user else update user
    if (result) {
      firebaseInstance.updateAppUser(this._authId, toJson());
    } else {
      firebaseInstance.createAppUser(this._authId, toJson());
    }
  }

  Future<AppUser> getUser(String authId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(authId).get();
    var appUserMap = userDoc.data();
    return AppUser.fromMap(appUserMap);
  }

  void loadInfo(List<QueryDocumentSnapshot> users) {
    var user = getAppUserInList(users);
    if (user != null) {
      this.loggedIn = user["logged_in"];
      this.signedWaiver = user["signed_waiver"];
      this.bikeCheckedOut = user["bike_checked_out"];
    }
  }

  // check if AppUser is In DB
  Future<bool> isInDb() async {
    return await firebaseInstance.documentAuthIdExists(_authId);
  }

  // find user in list of users and return Map of its properties
  Map<String, dynamic> getAppUserInList(List<QueryDocumentSnapshot> users) {
    Map<String, dynamic> result;
    for (final user in users) {
      if (user.id == this._authId) {
        result = user.data();
        return result;
      }
    }
  }

  String get authId => this._authId;

  set setAuthId(String authId) {
    this._authId = authId;
  }

  bool get isLoggedIn => this.loggedIn;

  set setLoggedIn(bool tmp) {
    this.loggedIn = tmp;
  }

  bool get hasSignedWaiver => this.signedWaiver;

  set setSignedWaiver(bool tmp) {
    this.signedWaiver = tmp;
  }

  bool get hasBikeCheckedOut => this.bikeCheckedOut;

  set setBikeCheckedOut(bool tmp) {
    this.loggedIn = tmp;
  }
}
