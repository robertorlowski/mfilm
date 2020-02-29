import 'package:flutter/material.dart';
import 'package:mfilm/app.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(ScopedModel<AppModel>(
      model: AppModel(sharedPreferences), child: FilmApp()));
}
