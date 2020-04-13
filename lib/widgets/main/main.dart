import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/util/styles.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/widgets/main/main_rows.dart';
import 'package:mfilm/widgets/main/main_col.dart';
import 'package:scoped_model/scoped_model.dart';

enum TypeView { ROW, COL }

class MainPage extends StatefulWidget {
  @override
  State createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  MediaType mediaType = MediaType.db;
  List<Widget> rowsMedia;
  TypeView _typeView = TypeView.COL;
  List<Genres> genresList = [];

  final MediaProvider videoProvider = MovieProviderVideo(sysLanguage);
  final MediaProvider dbProvider = MovieProviderDb(sysLanguage);

  MediaProvider _getProvider() {
    switch (mediaType) {
      case MediaType.db:
        return dbProvider;
      default:
        return videoProvider;
    }
  }

  _changeView() {
    setState(() {
      if (TypeView.ROW == _typeView) {
        _typeView = TypeView.COL;
      } else {
        _typeView = TypeView.ROW;
      }
    });
  }

  AppBar prepareAppBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
      actions: <Widget>[
        TypeView.ROW == _typeView
            ? IconButton(
                icon: Icon(Icons.view_stream, color: Colors.white),
                onPressed: () => _changeView())
            : IconButton(
                icon: Icon(Icons.view_module, color: Colors.white),
                onPressed: () => _changeView()),
        IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () => goToFavorites(context, mediaType, _getProvider())),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () => goToSearch(context, _getProvider()),
        )
      ],
      title: Text("mFilm"),
    );
  }

  Widget prepareDrawer(String sortBy) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              //decoration: BoxDecoration(color: primary),
              padding: const EdgeInsets.all(0.0),
              child: Image(image: AssetImage('assets/mfilm.png'))),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("movies"),
                style: TextStyle(
                    fontSize: 16.0,
                    color: (mediaType == MediaType.db)
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.subhead.color)),
            selected: mediaType == MediaType.db,
            trailing: Icon(Icons.local_movies,
                color: (mediaType == MediaType.db)
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.subhead.color),
            onTap: () {
              _changeMediaType(MediaType.db);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("trailers"),
                style: TextStyle(
                    fontSize: 16.0,
                    color: (mediaType == MediaType.video)
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.subhead.color)),
            selected: mediaType == MediaType.video,
            trailing: Icon(Icons.local_movies,
                color: (mediaType == MediaType.video)
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textTheme.subhead.color),
            onTap: () {
              _changeMediaType(MediaType.video);
              Navigator.of(context).pop();
            },
          ),
          Divider(
            height: 5.0,
          ),
          ListTile(
            title: Text(AppLocalizations.of(context).translate("settings"),
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.subhead.color)),
            subtitle: Row(
              //crossAxisAlignm
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(AppLocalizations.of(context).translate("sort_by"),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).textTheme.subhead.color)),
                Container(
                    height: 25,
                    width: 200,
                    child: ScopedModelDescendant<AppModel>(
                      builder: (context, child, AppModel model) =>
                          DropdownButton<String>(
                              value: sortBy,
                              isDense: true,
                              isExpanded: true,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 1,
                                color: Colors.white54,
                              ),
                              onChanged: (String newValue) {
                                model.defaultSortBy = newValue;
                                _changeMediaType(mediaType);
                                Navigator.of(context).pop();
                              },
                              items: moveSortBy
                                  .map<DropdownMenuItem<String>>((ooo) {
                                return DropdownMenuItem<String>(
                                    value: ooo,
                                    child: Text(AppLocalizations.of(context)
                                        .translate(ooo)));
                              }).toList()),
                    )),
              ],
            ),
          ),
          Divider(
            height: 5.0,
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).translate("close_app"),
              style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.subhead.color),
            ),
            trailing: Icon(Icons.close,
                color: Theme.of(context).textTheme.subhead.color),
            onTap: () => exit(0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: primary,
      appBar: prepareAppBar(),
      drawer: ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) =>
            prepareDrawer(model.defaultSortBy),
      ),
      body: _typeView == TypeView.ROW
          ? MainRowsWidget(_getProvider(), mediaType)
          : MainColWidget(_getProvider(), mediaType),
    );
  }

  void _changeMediaType(MediaType type) {
    setState(() {
      mediaType = type;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
