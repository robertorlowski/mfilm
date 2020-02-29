import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/widgets/home_page.dart';
import 'package:scoped_model/scoped_model.dart';

class FilmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => MaterialApp(
        title: 'mFilm',
        theme: model.theme,
        home: HomePage(),
      ),
    );
  }
}
