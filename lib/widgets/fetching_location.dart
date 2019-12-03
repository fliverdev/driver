import 'package:driver/utils/text_styles.dart';
import 'package:driver/utils/translations.dart';
import 'package:driver/utils/ui_helpers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FetchingLocation extends StatelessWidget {
  final String language;
  FetchingLocation({Key key, @required this.language}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: invertInvertColorsStrong(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 175.0,
                ),
                Container(
                  width: 225.0,
                  height: 225.0,
                  child: FlareActor(
                    'assets/flare/fetching_location.flr',
                    animation: 'animation',
                  ),
                ),
                Text(
                  'Fetching location... ${onboardingPage2Heading(language)}',
                  style: isThemeCurrentlyDark(context)
                      ? TitleStyles.white
                      : TitleStyles.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
