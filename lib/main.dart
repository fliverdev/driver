import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:driver/pages/home_page.dart';
import 'package:driver/utils/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(
        primaryColor: MyColors.primaryColor,
        accentColor: MyColors.accentColor,
        brightness: brightness,
//        fontFamily: '',
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Fliver Driver',
          theme: theme,
          home: MyHomePage(),
        );
      },
    );
  }
}
