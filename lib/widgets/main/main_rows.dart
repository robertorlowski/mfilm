import 'package:flutter/material.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/media_list_small/media_list_small.dart';

class MainRowsWidget extends StatefulWidget {
  final MediaProvider _provider;
  final MediaType _mediaType;

  MainRowsWidget(this._provider, this._mediaType, String sortBy)
      : super(key: Key(_mediaType.toString() + sortBy));

  @override
  State createState() => MainRowsWidgetState();
}

class MainRowsWidgetState extends State<MainRowsWidget> {
  List<Widget> data;

  _prepareData() async {
    List<Widget> _rrr = List<Widget>();

    try {
      List<Genres> list = await widget._provider.loadGenres();
      for (Genres ggg in list) {
        _rrr.add(_crrateRow([ggg]));
      }
      setState(() => data = _rrr);
    } catch (e) {
      return [];
    }
  }

  Widget _crrateRow(List<Genres> genreIDs) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: MediaListSmall(
                widget._mediaType,
                widget._provider,
                genreIDs,
              )),
        ),
      ]),
    );
  }

  @override
  void initState() {
    _prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data != null
        ? CustomScrollView(slivers: data)
        : Center(child: CircularProgressIndicator());
  }

/*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(slivers: snapshot.data);
        } else {
          return new Center(child: CircularProgressIndicator());
        }
      },
    );
  }
*/

}
