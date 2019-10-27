import 'package:driver/utils/colors.dart';
import 'package:driver/utils/text_styles.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: MyColors.light,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200.0,
                  height: 200.0,
                  child: FlareActor(
                    'assets/flare/no_connection.flr',
                    animation: 'animation',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Oops...there\'s no Internet!',
                  style: MyTextStyles.titleStyleDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
