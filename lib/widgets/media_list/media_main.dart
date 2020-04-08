import 'package:flutter/cupertino.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/media_list_small/media_list_small.dart';

class MainList extends StatefulWidget {
  final List<Genres> genreIDs;
  final MediaProvider provider;
  final MediaType mediaType;

  MainList(this.mediaType, this.genreIDs, this.provider);

  @override
  MainListState createState() {
    return MainListState();
  }
}

class MainListState extends State<MainList> {
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
          widget.mediaType,
          widget.provider,
          widget.genreIDs,
        ));
  }
}
