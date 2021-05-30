import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import 'firebase_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final firebaseService = FirebaseService(FirebaseFirestore.instance);

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Map> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // if email account has not been verified
      if (!_firebaseAuth.currentUser.emailVerified) {
        var key = await _firebaseAuth.currentUser.sendEmailVerification();
        await _firebaseAuth.signOut();
        return formatMsg(
            false, "Please verify email. Verification email re-sent.");
      }

      // add user to firestore db if not there yet else just update login
      AppUser appUser = new AppUser();
      appUser.setAuthId = userCredential.user.uid;
      bool inDb = await firebaseService.documentAuthIdExists(appUser.authId);
      if (inDb) {
        print("User already in Firestore db... updating logged_in");
        firebaseService.updateAppUserLoggedInStatus(true, appUser.authId);
        // check if user has been locked out by app
        var userDoc = await firebaseService.getDocumentFromCollection(
            "users", appUser.authId);
        if (userDoc["locked_out"] == true) {
          final firebaseInstance = FirebaseService(FirebaseFirestore.instance);
          firebaseInstance.updateAppUserLoggedInStatus(false, appUser.authId);
          //await _firebaseAuth.signOut();
          return formatMsg(false, "User account has been suspended");
        }
      } else {
        appUser.upload();
      }
      final firebaseInstance = FirebaseService(FirebaseFirestore.instance);
      firebaseInstance.updateAppUserLoggedInStatus(true, appUser.authId);
      print("Successfuly signed in");
      return formatMsg(true, "Successfuly signed in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return formatMsg(false, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return formatMsg(false, 'Wrong password provided for that user.');
      } else if (e.code == 'too-many-requests') {
        return formatMsg(false, 'Please verify email. Email previously sent.');
      }
    } catch (e) {
      // something has gone terribly wrong
      print(e);
      return formatMsg(false, e);
    }
    return formatMsg(false, null);
  }

  Future<Map> signUp({String email, String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser.sendEmailVerification();
      // put app user in Firestore db
      AppUser appUser = new AppUser();
      appUser.setAuthId = userCredential.user.uid;
      appUser.upload();
      await _firebaseAuth.signOut();
      return formatMsg(true, "Please check your email to verify.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return formatMsg(false, 'The account already exists for that email.');
      } else if (e.code == 'weak-password') {
        return formatMsg(false, 'The password provided is too weak.');
      }
    } catch (e) {
      // something has gone terribly wrong
      print(e);
      return formatMsg(false, e);
    }
    return formatMsg(false, null);
  }

  Future<void> resetPassword({String email}) async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // something has gone terribly wrong
      print(e);
    }
  }
}

formatMsg(success, message) {
  return {"success": success, "message": message};
}
