import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/widgets/home_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:ui' as ui;

class FilmApp extends StatelessWidget {
  // This widget is the root of your application.
  FilmApp();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => MaterialApp(
        locale: Locale(ui.window.locale.languageCode),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('pl', 'PL'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        title: 'mFilm',
        theme: model.theme,
        home: HomePage(),
      ),
    );
  }
}
