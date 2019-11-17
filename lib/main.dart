import 'package:driver/utils/colors.dart';
import 'package:driver/utils/first_page.dart';
import 'package:driver/utils/locale.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(
        fontFamily: 'LexendDeca',
        primaryColor: MyColors.primaryColor,
        accentColor: MyColors.accentColor,
        brightness: brightness, // default is dark
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          supportedLocales: [
            Locale('en', 'US'), // English
            Locale('hi', ''), // Hindi
            Locale('mr', ''), // Marathi
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          title: 'Fliver Driver',
          theme: theme,
          home: FirstPage(),
        );
      },
    );
  }
}
