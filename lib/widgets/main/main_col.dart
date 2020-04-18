import 'package:flutter/material.dart';
import 'package:netfilm/i18/app_localizations.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/util/mediaproviders.dart';
import 'package:netfilm/util/utils.dart';
import 'package:netfilm/widgets/media_list/media_list.dart';

class MainColWidget extends StatefulWidget {
  final MediaProvider _provider;
  final MediaType _mediaType;

  MainColWidget(this._provider, this._mediaType)
      : super(key: Key(_mediaType.toString()));

  @override
  State createState() => MainColWidgetState();
}

class MainColWidgetState extends State<MainColWidget> {
  PageController _pageController;
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
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
    ]);
  }

  List<BottomNavigationBarItem> _getNavBarItems() {
    if (widget._mediaType == MediaType.video) {
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
    } else if (widget._mediaType == MediaType.db) {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text(AppLocalizations.of(context).translate(moveSortBy[0]))),
        BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text(AppLocalizations.of(context).translate(moveSortBy[1]))),
      ];
    } else {
      return [];
    }
  }

  List<Widget> _getMediaList() {
    if (widget._mediaType == MediaType.video) {
      return <Widget>[
        MediaList(widget._provider, "popular", key: Key("movies-popular")),
        MediaList(widget._provider, "upcoming", key: Key("movies-upcoming")),
        MediaList(widget._provider, "top_rated", key: Key("movies-top_rated")),
      ];
    } else if (widget._mediaType == MediaType.db) {
      return <Widget>[
        MediaList(
            widget._provider, getSortByKey(widget._mediaType, moveSortBy[0]),
            key: Key(widget._mediaType.toString() + moveSortBy[0])),
        MediaList(
            widget._provider, getSortByKey(widget._mediaType, moveSortBy[1]),
            key: Key(widget._mediaType.toString() + moveSortBy[1])),
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
