import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/util/styles.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/widgets/media_list/media_main.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  MediaType mediaType = MediaType.movie;
  List<Widget> rowsMedia;
  String sortValue = moveSortBy.keys.first;
  final MediaProvider movieProvider = MovieProvider();

  AppBar prepareAppBar() {
    return AppBar(
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
            title: Text("Settings",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).textTheme.subhead.color)),
            subtitle: Row(
              //crossAxisAlignm
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Sort by:",
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
                                setState(() {
                                  model.setMovieSortBy(newValue);
                                });
                              },
                              items: moveSortBy.entries
                                  .map<DropdownMenuItem<String>>((ooo) {
                                print(ooo);
                                return DropdownMenuItem<String>(
                                  value: ooo.key,
                                  child: Text(ooo.value),
                                );
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
    );
  }

  prepareList(Widget widget) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: widget,
        ),
      ]),
    );
  }

  _prepareContent() async {
    List<Widget> lll = new List<Widget>();

    try {
      List<Genres> list = await movieProvider.loadGenres(sysLanguage);
      for (Genres ggg in list) {
        lll.add(prepareList(new MainList([ggg])));
      }
      setState(() => rowsMedia = lll);
    } catch (e) {
      e.toString();
    }
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
              prepareDrawer(model.getMovieSortBy()),
        ),
        body: CustomScrollView(
            slivers: rowsMedia == null
                ? <Widget>[
                    prepareList(new Center(child: CircularProgressIndicator()))
                  ]
                : rowsMedia));
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  @override
  void initState() {
    _prepareContent();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
