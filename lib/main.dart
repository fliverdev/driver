import 'package:driver/utils/colors.dart';
import 'package:driver/utils/first_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:driver/utils/locale.dart';
import 'package:driver/pages/map_view_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:driver/utils/AppLanguage.dart';
import 'package:provider/provider.dart';

void main() async {
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}



class MyApp extends StatelessWidget {

  final AppLanguage appLanguage;

  MyApp({this.appLanguage});


  @override
  Widget build(BuildContext context) {


    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(
        fontFamily: 'AvenirNextRounded',
        primaryColor: MyColors.primary,
        accentColor: MyColors.accent,
        brightness: brightness, // default is dark
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(

          supportedLocales: [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
        Locale('mr', ''), // Marathi
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ], // causes the function to crash
          title: 'Fliver Driver',
          theme: theme,
          home: FirstPage(),
        );
      },
    );
  }
}
