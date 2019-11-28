import 'package:driver/pages/map_view_page.dart';
import 'package:driver/utils/colors.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOnboardingPage1 extends StatelessWidget {
  final SharedPreferences helper;
  final bool flag;
  final String identity;
  MyOnboardingPage1(
      {Key key,
      @required this.helper,
      @required this.flag,
      @required this.identity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyOnboardingPage2 extends StatelessWidget {
  final SharedPreferences helper;
  final bool flag;
  final String identity;
  MyOnboardingPage2(
      {Key key,
      @required this.helper,
      @required this.flag,
      @required this.identity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.8;
    return Material(
      child: Container(
        color: MyColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  Text(
                    'Bhada Dhundo!',
                    style: HeadingStyles.black,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 39.0,
                            height: 42.0,
                            child: Image.asset(
                              'assets/other/cluster.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'How does it work?',
                              style: SubTitleStyles.black,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Swipe the button to notify nearby Drivers about your location.',
                              style: BodyStyles.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 32.0,
                            height: 38.0,
                            child: Image.asset(
                              'assets/other/notification.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'How do I get to know?',
                              style: SubTitleStyles.black,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'When 3 or more Riders in an area mark their location, a hotspot is created and Drivers get notified.',
                              style: BodyStyles.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 25.0,
                            height: 36.0,
                            child: Image.asset(
                              'assets/other/rupee.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Is it free?',
                              style: SubTitleStyles.black,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Fuck yes!!!',
                              style: BodyStyles.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  ButtonTheme(
                    height: 50.0,
                    minWidth: 180.0,
                    child: RaisedButton(
                      child: Text(
                        'Let\'s Go!',
                        style: BodyStyles.white,
                      ),
                      color: MyColors.black,
                      splashColor: MyColors.primary,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        helper.setBool('isFirstLaunch', false);
                        helper.setString('uuid', identity);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyMapViewPage(
                                    helper: prefs, identity: identity)),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
