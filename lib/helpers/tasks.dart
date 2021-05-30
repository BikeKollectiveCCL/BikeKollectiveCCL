import 'package:bikekollective/services/authentication_service.dart';
import 'package:bikekollective/services/firebase_service.dart';
import 'package:bikekollective/services/local_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:provider/provider.dart';

const eightHourCheck = 'eightHourCheck';
const cancelAllNotifications = 'cancelAllNotifications';
const cancellAllBgTasks = 'cancellAllBgTasks';
const intervalCheck = 'intervalCheck';
const cancelBgTaskByName = "cancelBgTaskByName";

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    FirebaseService firebaseService =
        FirebaseService(FirebaseFirestore.instance);
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    LocalNotification.initializer();
    var payload = inputData;
    switch (task) {
      case eightHourCheck:
        {
          print('Checking to see if a bike has been checked out > 8 hours');
          print("Seing out notification from eightHourCheck");
          print(
              '${payload["ALLOWED_RIDE_TIME_MIN"]} minutes have elapsed since bike id ${payload["bikeID"]} checked out');

          // get ride document checkout

          var doc = await firebaseService.getDocumentFromCollection(
              "rides", payload["rideID"]);

          // check if document exists
          if (doc != null) {
            // check if there is a return_type attribute
            // if not, then bike has NOT been returned
            // start backgound job to keep checking
            if (doc["return_time"] == null) {
              // initiatite periodic job
              await Workmanager().registerPeriodicTask(
                  "intervalCheck_${payload["rideID"]}", "intervalCheck",
                  inputData: payload,
                  frequency: Duration(
                      minutes:
                          payload["REMIND_USER_RETURN_BIKE_INTERVAL_MIN"]));
            } else {
              print("Bike has been returned for Ride ID ${payload['rideID']}");
            }
            // else do nothing b/c ride doc has a return_time attribute
            // meaning bike HAS ALREADY been returned for that specific user
          } else {
            // error if this gets hit
            print("Error: Ride document has not been created in Firebase DB");
          }
        }
        break;
      case intervalCheck:
        {
          print(
              'intervalCheck: Job Checking periodically to see if a bike has been returned');

          // get ride document checkout
          var doc = await firebaseService.getDocumentFromCollection(
              "rides", payload["rideID"]);

          if (doc != null) {
            // check if bike has been returned before lock-account time threshold
            if (!timeToLockUserOut(payload["checkoutTime_epoch_ms"],
                payload["ACCOUNT_LOCKOUT_THRESHOLD_MIN"])) {
              // if not, send remidner notification
              print(
                  "intervalCheck: Sending out remindToReturnBike notification");
              await LocalNotification.remindToReturnBike();
            } else {
              // update locked_out attribute in Firebase
              print(
                  "intervalCheck: Locking out user. Setting Firebase attribute locked_out in users collection");
              firebaseService.setLockoutAttributeInUser(payload["userID"]);
              // send final notficiation that account was locked
              print(
                  "intervalCheck: Sending out lockOutUserNotifcation notification");
              await LocalNotification.lockOutUserNotifcation();

              // log out user
              print("intervalCheck: Signout out user from FirebaseAuth");
              AuthenticationService authenticationService =
                  AuthenticationService(FirebaseAuth.instance);
              //await authenticationService.signOut();

              // create mew job handler that kills speicifc job
              print(
                  "intervalCheck: Starting new job (cancelBgTaskByName) to cancel curent job intervalCheck_${payload['rideID']}");
              // stop interval job and lock out user
              await Workmanager().registerOneOffTask(
                  "cancelBgTaskByName_${payload["rideID"]}",
                  "cancelBgTaskByName",
                  inputData: payload);
            }
          } else {
            // someting has gone horribly wrong if we get here
            print("intervalCheck: Firebase doc not found");
          }
        }
        break;
      case cancelBgTaskByName:
        {
          print(
              "cancelBgTaskByName: Cancelling job intervalCheck_${payload['rideID']}");
          await Workmanager()
              .cancelByUniqueName("intervalCheck_${payload['rideID']}");
        }
        break;
      case cancelAllNotifications:
        {
          print("cancelAllNotifications: Cancelling all notifcations");
          LocalNotification.initializer();
          await LocalNotification.cancelAllNotifications();
        }
        break;
      case cancellAllBgTasks:
        {
          print("cancellAllBgTasks: Cancelling all Background Tasks");
          await Workmanager().cancelAll();
        }
        break;
      default:
        print("default (job): Inside executeTask..No task matching");
        break;
    }
    return Future.value(true);
  });
}

// takes in args in milliseconds and returns seconds
int getElapsedSecsByEpoch(int time1, int time2) {
  int difference;
  if (time1 > time2) {
    difference = time1 - time2;
  } else if (time2 > time1) {
    difference = time2 - time1;
  } else {
    return 0;
  }
  // convert millisecond to seconds
  difference = difference ~/ 1000;
  return difference;
}

bool timeToLockUserOut(int checkout_epoch_ms, int threshold_min) {
  // check how much time has elapsed since bike checkout time
  var timenow = DateTime.now();
  var elapsedTimeInSecs =
      getElapsedSecsByEpoch(checkout_epoch_ms, timenow.millisecondsSinceEpoch);
  if (elapsedTimeInSecs ~/ 60 < threshold_min) {
    // user still has time to return bike before being lcoked out
    print(
        "timeToLockUserOut-->FALSE: user still has time to return bike before being locked out");
    return false;
  } else {
    print(
        "timeToLockUserOut-->TRUE: User has NO time to return bike. LOCK USER OUT!");
    return true;
  }
}
