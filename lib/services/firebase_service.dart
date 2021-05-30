import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firebaseDB;

  FirebaseService(this._firebaseDB);

  Stream<QuerySnapshot> getAppUserCollectionStream() =>
      _firebaseDB.collection('users').snapshots();

  Stream<DocumentSnapshot> documentStream(collection, docID) =>
      _firebaseDB.collection(collection).doc(docID).snapshots();

  Future<void> updateAppUserLoggedInStatus(bool tmp, String authId) {
    // only update if document/user exists in DB
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("Checking if User id $authId is in DB..");
      if (documentSnapshot.exists) {
        return _firebaseDB
            .collection('users')
            .doc(authId)
            .update({'logged_in': tmp})
            .then((value) =>
                print("User id $authId logged_in status updated to $tmp in DB"))
            .catchError((error) => print(
                "Failed to update user id $authId logged_in status : $error"));
      } else {
        print("User id $authId NOT in DB..");
      }
    }).catchError((error) {
      print("Failed to get doc/user id $authId with erro: $error");
    });
  }

  Future<void> updateAppUserBikeCheckedOutStatus(bool tmp, String authId) {
    // only update if document/user exists in DB
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("Checking if User id $authId is in DB..");
      if (documentSnapshot.exists) {
        print("User id $authId FOUND in DB..");
        return _firebaseDB
            .collection('users')
            .doc(authId)
            .update({'bike_checked_out': tmp})
            .then((value) => print(
                "User id $authId bike_checked_out status updated to $tmp in DB"))
            .catchError((error) => print(
                "Failed to update user id $authId bike_checked_out status : $error"));
      } else {
        print("User id $authId NOT in DB..");
      }
    }).catchError((error) {
      print("Failed to get doc/user id $authId with erro: $error");
    });
  }

  Future<void> updateAppUserSignedWaiverStatus(bool tmp, String authId) {
    // only update if document/user exists in DB
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("Checking if User id $authId is in DB..");
      if (documentSnapshot.exists) {
        print("User id $authId FOUND in DB..");
        return _firebaseDB
            .collection('users')
            .doc(authId)
            .update({'signed_waiver': tmp})
            .then((value) => print(
                "User id $authId signed_waiver status updated to $tmp in DB"))
            .catchError((error) => print(
                "Failed to update user id $authId signed_waiver status : $error"));
      } else {
        print("User id $authId NOT in DB..");
      }
    }).catchError((error) {
      print("Failed to get doc/user id $authId with erro: $error");
    });
  }

  Future<void> updateAppUser(String authId, Map userValues) {
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .update(userValues)
        .then((value) => print("User $authId was updated in the DB"))
        .catchError(
            (onError) => print("Failed to update user $authId: $onError"));
  }

  Future<void> createAppUser(String authId, Map userValues) {
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .set(userValues)
        .then((value) => print("User $authId was created in the DB"))
        .catchError(
            (onError) => print("Failed to create user $authId: $onError"));
  }

  Future<bool> documentAuthIdExists(String authId) {
    return _firebaseDB
        .collection('users')
        .doc(authId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("Checking if User id $authId is in DB..");
      if (documentSnapshot.exists) {
        print("User id $authId FOUND in DB..");
        return true;
      } else {
        print("User id $authId NOT in DB..");
        return false;
      }
    }).catchError((error) {
      print("Failed to get doc/user id $authId with erro: $error");
      return false;
    });
  }

  Future<dynamic> getDocumentFromCollection(String collection, String docId) {
    return _firebaseDB
        .collection(collection)
        .doc(docId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("Checking if doc id $docId is in DB in collection $collection..");
      if (documentSnapshot.exists) {
        print("Doc id $docId FOUND in DB in collection $collection..");
        return documentSnapshot.data();
      } else {
        print("Doc id $docId NOT in DB in collection $collection..");
        return null;
      }
    }).catchError((error) {
      print("Failed to get doc id $docId with erro: $error");
      return null;
    });
  }

  Future<void> setLockoutAttributeInUser(String docId) {
    return _firebaseDB
        .collection("users")
        .doc(docId)
        .update({'locked_out': true})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}
