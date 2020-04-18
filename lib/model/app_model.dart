import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/util/utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends Model {
  final SharedPreferences _sharedPrefs;
  Set<MediaItem> _favorites = Set();
  static const _THEME_KEY = "theme_prefs_key";

  static const _SORT_KEY = "sort_key";
  String _currentSortBy = moveSortBy[0];

  static const _FAVORITES_KEY = "media_favorites_key";

  static const _LANG_CODE_ = "language_code";
  static const _COUNTRY_CODE_ = "countryCode";
  Locale _appLocale = Locale('en');

  static List<ThemeData> _themes = [ThemeData.dark(), ThemeData.light()];
  int _currentTheme = 0;

  ThemeData get theme => _themes[_currentTheme];

  AppModel(this._sharedPrefs, Locale locale) {
    _currentTheme = _sharedPrefs.getInt(_THEME_KEY) ?? 0;
    _currentSortBy = _sharedPrefs.getString(_SORT_KEY) ?? moveSortBy[0];

    _favorites.addAll(_sharedPrefs
            .getStringList(_FAVORITES_KEY)
            ?.map((value) => MediaItem.fromPrefsJson(json.decode(value))) ??
        Set());

    if (_sharedPrefs.getString('language_code') != null) {
      _appLocale = Locale(_sharedPrefs.getString('language_code'));
    }

    changeLanguage(locale);
  }

  List<MediaItem> favoriteMovies(MediaType mediaType) =>
      _favorites.where((MediaItem item) => item.type == mediaType).toList();

  set defaultSortBy(String value) {
    _currentSortBy = value;
    _sharedPrefs.setString(_SORT_KEY, _currentSortBy);
    notifyListeners();
  }

  String get defaultSortBy {
    return _currentSortBy;
  }

  void toggleTheme() {
    _currentTheme = (_currentTheme + 1) % _themes.length;
    _sharedPrefs.setInt(_THEME_KEY, _currentTheme);
    notifyListeners();
  }

  bool isItemFavorite(MediaItem item) =>
      _favorites?.where((MediaItem media) => media.id == item.id)?.length ==
          1 ??
      false;

  void toggleFavorites(MediaItem favoriteItem) {
    !isItemFavorite(favoriteItem)
        ? _favorites.add(favoriteItem)
        : _favorites
            .removeWhere((MediaItem item) => item.id == favoriteItem.id);

    notifyListeners();

    _sharedPrefs.setStringList(
        _FAVORITES_KEY,
        _favorites
            .toList()
            .map((MediaItem favoriteItem) => json.encode(favoriteItem.toJson()))
            .toList());
  }

  Locale get appLocal => _appLocale ?? Locale("en");

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }

    if (type == Locale("pl")) {
      _appLocale = Locale("pl");
      await _sharedPrefs.setString(_LANG_CODE_, 'pl');
      await _sharedPrefs.setString(_COUNTRY_CODE_, 'PL');
    } else {
      _appLocale = Locale("en");
      await _sharedPrefs.setString(_LANG_CODE_, 'en');
      await _sharedPrefs.setString(_COUNTRY_CODE_, 'US');
    }
    notifyListeners();
  }
}
