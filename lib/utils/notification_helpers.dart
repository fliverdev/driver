import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  print('initNotifications() called');

  var initSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initSettingsIOS = IOSInitializationSettings();
  var initSettings =
      InitializationSettings(initSettingsAndroid, initSettingsIOS);

  notificationsPlugin.initialize(initSettings);
}

Future<void> createDailyNotification(Time notificationTime) async {
  print('createDailyNotification() called');

  var androidSpecifics = AndroidNotificationDetails(
    'channelId',
    'Location Marking Suggestions',
    'Reminders to mark your location when you usually need a Rickshaw',
    importance: Importance.Max,
    priority: Priority.Max,
    icon: 'app_icon',
  );
  var iOSSpecifics = IOSNotificationDetails();
  var platformSpecifics = NotificationDetails(androidSpecifics, iOSSpecifics);

  await notificationsPlugin.showDailyAtTime(
    0,
    'Looking for a Rider?',
    'Open Fliver and view locations!',
    notificationTime,
    platformSpecifics,
  );

  print('Notification created: $notificationTime');
}
