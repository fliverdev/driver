import 'package:driver/utils/colors.dart';
import 'package:driver/utils/first_page.dart';
import 'package:driver/utils/notification_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initNotifications();

  createDailyNotification(Time(9, 0, 0));
  createDailyNotification(Time(12, 0, 0));
  createDailyNotification(Time(17, 0, 0));
  createDailyNotification(Time(18, 30, 0));
  createDailyNotification(Time(20, 0, 0));
  createDailyNotification(Time(21, 30, 0));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    DateTime startTime = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, 6, 0); // 6AM
    DateTime endTime = DateTime(currentDateTime.year, currentDateTime.month,
        currentDateTime.day, 18, 0); // 6PM
    Brightness brightness;

    if (currentDateTime.isAfter(startTime) &&
        currentDateTime.isBefore(endTime)) {
      // 6AM to 6PM
      // light mode
      print('It is day!');
      brightness = Brightness.light;
    } else {
      // dark mode
      print('It is night!');
      brightness = Brightness.dark;
    }

    return MaterialApp(
      title: 'Fliver Driver',
      theme: ThemeData(
        fontFamily: 'AvenirNextRounded',
        primaryColor: MyColors.primary,
        accentColor: MyColors.accent,
        brightness: brightness,
      ),
      home: FirstPage(),
    );
  }
}
