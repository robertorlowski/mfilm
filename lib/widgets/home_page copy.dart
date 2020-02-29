import 'package:flutter/material.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/widgets/media_list/media_list.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;
  MediaType mediaType = MediaType.movie;

  final MediaProvider movieProvider = MovieProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () => goToFavorites(context)),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => goToSearch(context),
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
                title: Text("Movies info",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: (mediaType == MediaType.movie)
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.subhead.color)),
                selected: mediaType == MediaType.movie,
                trailing: Icon(Icons.local_movies,
                    color: (mediaType == MediaType.movie)
                        ? Theme.of(context).accentColor
                        : Theme.of(context).textTheme.subhead.color),
                onTap: () {
                  _changeMediaType(MediaType.movie);
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text(
                  "Close",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.subhead.color),
                ),
                trailing: Icon(Icons.close,
                    color: Theme.of(context).textTheme.subhead.color),
                onTap: () => Navigator.of(context).pop(),
              )
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
    if (mediaType == MediaType.movie) {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), title: Text('Popular')),
        BottomNavigationBarItem(
            icon: Icon(Icons.update), title: Text('Upcoming')),
        BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Top Rated')),
      ];
    } else {
      return null;
    }
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  List<Widget> _getMediaList() {
    return (mediaType == MediaType.movie)
        ? <Widget>[
            MediaList(
              movieProvider,
              "popular",
              key: Key("movies-popular"),
            ),
            MediaList(movieProvider, "upcoming", key: Key("movies-upcoming")),
            MediaList(movieProvider, "top_rated", key: Key("movies-top_rated")),
          ]
        : null;
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
