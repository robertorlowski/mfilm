import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/utils.dart';
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
  List<Widget> data = List();

  List<Genres> _genres = List();
  int _pageNumber = 0;
  LoadingState _loadingState = LoadingState.INIT;
  bool _isLoading = false;

  _prepareData() async {
    try {
      _genres.clear();
      _pageNumber = 0;
      _isLoading = false;
      _loadingState = LoadingState.INIT;
      _genres = await widget._provider.loadGenres();
      _loadNextPage();
    } catch (e) {
      return [];
    }
  }

  void _loadNextPage() async {
    _isLoading = true;
    _loadingState = LoadingState.LOADING;
    try {
      List<Widget> _dd = List<Widget>();
      for (var _i = _pageNumber * 5;
          _i < _genres.length && _i < (_pageNumber + 1) * 5;
          _i++) {
        _dd.add(_crrateRow([_genres[_i]]));
      }

      setState(() {
        _loadingState = LoadingState.DONE;
        data.addAll(_dd);
        _isLoading = false;
        _pageNumber++;
      });
    } catch (e) {
      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        setState(() => _loadingState = LoadingState.ERROR);
      }
    }
  }

  Widget _crrateRow(List<Genres> genreIDs) {
    return Container(
        decoration: BoxDecoration(color: const Color(0xff222128)),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: MediaListSmall(
          widget._mediaType,
          widget._provider,
          genreIDs,
        ));
  }

  @override
  void initState() {
    _prepareData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data != null && data.length != 0
        ? Center(child: _getContentSection())
        : Center(child: CircularProgressIndicator());
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return ListView.builder(
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: false,
            itemCount: _genres.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading &&
                  index > (data.length * 0.8) &&
                  data.length != _genres.length) {
                _loadNextPage();
              }
              return data[index];
            });
      case LoadingState.ERROR:
        return Text(AppLocalizations.of(context).translate("an_error_occured"));
      case LoadingState.LOADING:
        return CircularProgressIndicator();
      default:
        return Container();
    }
  }
}
