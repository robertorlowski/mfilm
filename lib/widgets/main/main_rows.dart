import 'package:flutter/material.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/media_list/media_main.dart';

class MainRowsWidget extends StatefulWidget {
  final MediaProvider _provider;
  final MediaType _mediaType;
  final String _sortBy;

  MainRowsWidget(this._provider, this._mediaType, this._sortBy)
      : super(key: Key(_mediaType.toString() + _sortBy));

  @override
  State createState() => MainRowsWidgetState();
}

class MainRowsWidgetState extends State<MainRowsWidget> {
  Future<List<Widget>> _prepareData() async {
    List<Widget> _rrr = List<Widget>();
    try {
      List<Genres> list = await widget._provider.loadGenres();
      for (Genres ggg in list) {
        _rrr.add(_crrateRow(new MainList(
            widget._mediaType, [ggg], widget._provider, widget._sortBy)));
      }
      return _rrr;
    } catch (e) {
      return [];
    }
  }

  Widget _crrateRow(Widget widget) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: widget,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _prepareData(),
      builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(slivers: snapshot.data);
        } else {
          return new Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
