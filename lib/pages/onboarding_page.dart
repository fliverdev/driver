import 'package:driver/pages/map_view_page.dart';
import 'package:driver/utils/colors.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/translations.dart';
import 'package:flutter/cupertino.dart';
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
    return Material(
      child: Container(
        color: MyColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 170.0,
                  height: 54.0,
                  child: Image.asset(
                    'assets/logo/text-black.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/other/rickshaw.png',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Choose a language:',
                  style: TitleStyles.black,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('English'),
                      color: MyColors.black,
                      textColor: MyColors.white,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      onPressed: () {
                        helper.setString('language', 'en');

                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return MyOnboardingPage2(
                              helper: helper,
                              identity: identity,
                              language: 'en');
                        }));
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    RaisedButton(
                      child: Text('हिंदी'),
                      color: MyColors.black,
                      textColor: MyColors.white,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      onPressed: () {
                        helper.setString('language', 'hi');

                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return MyOnboardingPage2(
                              helper: helper,
                              identity: identity,
                              language: 'hi');
                        }));
                      },
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    RaisedButton(
                      child: Text('मराठी'),
                      color: MyColors.black,
                      textColor: MyColors.white,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      onPressed: () {
                        helper.setString('language', 'mr');

                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return MyOnboardingPage2(
                              helper: helper,
                              identity: identity,
                              language: 'mr');
                        }));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyOnboardingPage2 extends StatelessWidget {
  final SharedPreferences helper;
  final String identity;
  final String language;
  MyOnboardingPage2(
      {Key key,
      @required this.helper,
      @required this.identity,
      @required this.language})
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
                    height: 100.0,
                  ),
                  Text(
                    onboardingPageHeading(language),
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
                              onboardingPageTitle1(language),
                              style: SubHeadingStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              onboardingPageTitle1Body1(language),
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
                              onboardingPageTitle2(language),
                              style: SubHeadingStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              onboardingPageTitle2Body2(language),
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
                              onboardingPageTitle3(language),
                              style: SubHeadingStyles.black,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              onboardingPageTitle3Body3(language),
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
                        helper.setBool('isFirstLaunch', false);
                        helper.setString('uuid', identity);

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyMapViewPage(
                                      helper: helper,
                                      identity: identity,
                                      language: language,
                                    )),
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
