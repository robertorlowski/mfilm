import 'package:flutter/cupertino.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/media_list_small/media_list_small.dart';

class MainList extends StatefulWidget {
  final List<Genres> genreIDs;
  MainList(this.genreIDs);

  @override
  MainListState createState() {
    return MainListState();
  }
}

class MainListState extends State<MainList> {
  final MediaProvider movieProvider = MovieProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: MediaListSmall(
          movieProvider,
          widget.genreIDs,
        ));
  }
}
