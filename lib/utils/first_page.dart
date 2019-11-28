import 'package:driver/pages/map_view_page.dart';
import 'package:driver/pages/onboarding_page.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  void firstPageChecker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    String uuid = prefs.getString('uuid') ?? Uuid().v4();
    // generates random uuid as string

    if (isFirstLaunch) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyOnboardingPage1(
                    helper: prefs,
                    flag: isFirstLaunch,
                    identity: uuid,
                  )),
          (Route<dynamic> route) => false);
      // very first launch since install
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyMapViewPage(helper: prefs, identity: uuid)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    firstPageChecker();
  }

  Widget build(BuildContext context) {
    return Container(
      color: invertInvertColorsStrong(context), // blank screen
    );
  }
}
