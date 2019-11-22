import 'package:driver/utils/colors.dart';
import 'package:driver/utils/locale.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:driver/widgets/sexy_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyCreditsPage extends StatefulWidget {
  @override
  _MyCreditsPageState createState() => _MyCreditsPageState();
}

class _MyCreditsPageState extends State<MyCreditsPage> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      print('Launching $url...');
      await launch(url);
    } else {
      print('Error launching $url!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: invertInvertColorsStrong(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 40.0,
                left: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    tooltip: 'Go back',
                    iconSize: 20.0,
                    color: invertColorsStrong(context),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    AppLocalizations.of(context).translate('titleCredits'),
                    style: isThemeCurrentlyDark(context)
                        ? MyTextStyles.titleStyleLight
                        : MyTextStyles.titleStyleDark,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.3, // increase/decrease tile height
                children: <Widget>[
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/credits/urmil.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContatinerName1'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.titleStyleLight
                                  : MyTextStyles.titleStyleDark,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContainerBody1'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.bodyStyleLightItalic
                                  : MyTextStyles.bodyStyleDarkItalic,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primaryColor,
                    onTap: () => _launchURL('https://urmilshroff.tech'),
                  ),
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  AssetImage('./assets/credits/priyansh.jpg'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContatinerName2'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.titleStyleLight
                                  : MyTextStyles.titleStyleDark,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContainerBody2'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.bodyStyleLightItalic
                                  : MyTextStyles.bodyStyleDarkItalic,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primaryColor,
                    onTap: () => _launchURL('https://github.com/prince1998'),
                  ),
                  SexyTile(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 75.0,
                          height: 75.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('./assets/credits/vinay.png'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContatinerName3'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.titleStyleLight
                                  : MyTextStyles.titleStyleDark,
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('creditsContainerBody3'),
                              style: isThemeCurrentlyDark(context)
                                  ? MyTextStyles.bodyStyleLightItalic
                                  : MyTextStyles.bodyStyleDarkItalic,
                            ),
                          ],
                        ),
                      ],
                    ),
                    splashColor: MyColors.primaryColor,
                    onTap: () => _launchURL('http://www.decaf.co.in'),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .translate('creditsFooter'),
                          style: isThemeCurrentlyDark(context)
                              ? MyTextStyles.bodyStyleLight
                              : MyTextStyles.bodyStyleDark,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Text(AppLocalizations.of(context)
                                  .translate('creditsButton1')),
                              textColor: invertColorsStrong(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () => _launchURL(
                                  'https://github.com/fliverdev/driver'),
                            ),
                            FlatButton(
                              child: Text(AppLocalizations.of(context)
                                  .translate('creditsButton2')),
                              textColor: invertColorsStrong(context),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              onPressed: () => _launchURL(
                                  'mailto:urmilshroff@gmail.com?subject=Fliver Driver feedback'),
                            ),
                          ],
                        ),
                      ],
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