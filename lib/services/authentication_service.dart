import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Map> signIn({String email, String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print("Successfuly signed in");
      return formatMsg(true, "Successfuly signed in");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return formatMsg(false, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return formatMsg(false, 'Wrong password provided for that user.');
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
}

formatMsg(success, message) {
  return {"success": success, "message": message};
}
