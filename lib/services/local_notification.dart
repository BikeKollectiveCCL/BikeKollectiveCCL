import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static AndroidNotificationDetails androidSettings;

  static initializer() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitialization);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static remindToReturnBike() async {
    var android = AndroidNotificationDetails("channel-id-remindToReturnBike",
        "remind-user-notification", "one-time-notifcation",
        importance: Importance.max, priority: Priority.high, playSound: true);

    var platform = new NotificationDetails(android: android);
    print("Inside remindToReturnBike");
    await _flutterLocalNotificationsPlugin.show(
        1,
        "Bike Kollective reminds reminder to return bike!",
        "- Only 24 hrs after initial bike checkout before account gets locked indefinitely.",
        platform,
        payload: "PAYLOAD GOES HERE");
  }

  static lockOutUserNotifcation() async {
    var android = AndroidNotificationDetails(
        "channel-id-lockOutUserNotifcation",
        "user-lock-notification",
        "one-time-notifcation",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true);

    var platform = new NotificationDetails(android: android);
    print("Inside instantNofitication");
    await _flutterLocalNotificationsPlugin.show(
        2,
        "Bike Kollective user account locked.",
        "- Bike checked out for more than 24 hours and not returned in time. Locking account indefinitely.",
        platform,
        payload: "This is the payload");
  }

  static cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print("Cancelled all further notifications");
  }
}
