import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/widgets/media_list/media_list.dart';

class HomePage2 extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage2> {
  PageController _pageController;
  int _page = 0;
  MediaType mediaType = MediaType.video;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () =>
                    goToFavorites(context, mediaType, _getProvider())),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => goToSearch(context, _getProvider()),
            )
          ],
          title: Text("mFilm"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  padding: const EdgeInsets.all(0.0),
                  child: Image(
                      image: AssetImage('assets/colorful-toothed-wheels.jpg'))),
              Divider(
                height: 5.0,
              ),
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
                  title: Text(
                    AppLocalizations.of(context).translate("close_app"),
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).textTheme.subhead.color),
                  ),
                  trailing: Icon(Icons.close,
                      color: Theme.of(context).textTheme.subhead.color),
                  onTap: () => exit(0))
            ],
          ),
        ),
        body: Stack(children: <Widget>[
          PageView(
            children: _getMediaList(),
            pageSnapping: true,
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _page = index;
              });
            },
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
              items: _getNavBarItems(),
              onTap: _navigationTapped,
              currentIndex: _page,
              unselectedItemColor: Colors.white,
            ),
          )
        ]));
  }

  List<BottomNavigationBarItem> _getNavBarItems() {
    if (mediaType == MediaType.video) {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            title: Text(AppLocalizations.of(context).translate("popular"))),
        BottomNavigationBarItem(
            icon: Icon(Icons.update),
            title: Text(AppLocalizations.of(context).translate("upcoming"))),
        BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text(AppLocalizations.of(context).translate("top_rated"))),
      ];
    } else if (mediaType == MediaType.db) {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up),
            title: Text(AppLocalizations.of(context).translate("popular"))),
        BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text(AppLocalizations.of(context).translate("top_rated"))),
      ];
    } else {
      return [];
    }
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
        _page = 0;
      });
    }
  }

  List<Widget> _getMediaList() {
    if (mediaType == MediaType.video) {
      return <Widget>[
        MediaList(_getProvider(), "popular", key: Key("movies-popular")),
        MediaList(_getProvider(), "upcoming", key: Key("movies-upcoming")),
        MediaList(_getProvider(), "top_rated", key: Key("movies-top_rated")),
      ];
    } else if (mediaType == MediaType.db) {
      return <Widget>[
        MediaList(_getProvider(), "popularity", key: Key("db-popularity")),
        MediaList(_getProvider(), "voteAverage", key: Key("db-voteAverage")),
      ];
    } else {
      return [];
    }
  }

  void _navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
