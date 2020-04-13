import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/genres.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/widgets/media_list_small/media_list_item_small.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaListSmall extends StatefulWidget {
  MediaListSmall(this.mediaType, this.provider, this.genreIDs, {Key key})
      : super(key: Key(mediaType.toString() + getGenreString(genreIDs)));

  final MediaProvider provider;
  final List<Genres> genreIDs;
  final MediaType mediaType;

  @override
  _MediaListSmallState createState() => _MediaListSmallState();
}

class _MediaListSmallState extends State<MediaListSmall> {
  List<MediaItem> _movies = List();
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.INIT;
  bool _isLoading = false;

  _init() {
    _movies.clear();
    _pageNumber = 1;
    _loadingState = LoadingState.INIT;
  }

  void _loadNextPage(String sorBy) async {
    _isLoading = true;
    _loadingState = LoadingState.LOADING;
    try {
      var nextMovies = await widget.provider.loadMediaForGenreIDs(
          getGenresForIds(widget.genreIDs),
          page: _pageNumber,
          sortBy: sorBy);
      setState(() {
        _loadingState = LoadingState.DONE;
        _movies.addAll(nextMovies);
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

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (
        context,
        child,
        AppModel model,
      ) =>
          Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5, 2, 0, 3),
            alignment: Alignment.centerLeft,
            child: Text(
              getGenreStringNames(widget.genreIDs).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            height: 280,
            //margin: EdgeInsets.symmetric(horizontal: 10),
            child: _getContentSection(model.defaultSortBy),
          )
        ],
      ),
    );
  }

  Widget _getContentSection(String sortBy) {
    sortBy = getSortByKey(widget.mediaType, sortBy);
    switch (_loadingState) {
      case LoadingState.INIT:
        _loadNextPage(sortBy);
        return Center(child: CircularProgressIndicator());

      case LoadingState.DONE:
        return ListView.builder(
            itemCount: _movies.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_movies.length * 0.7)) {
                _loadNextPage(sortBy);
              } else {
                _loadingState = LoadingState.INIT;
              }
              return MediaListSmallItem(_movies[index], widget.provider);
            });
      case LoadingState.ERROR:
        return Text('Sorry, there was an error loading the data!');
      case LoadingState.LOADING:
        return Center(child: CircularProgressIndicator());
      default:
        return Container();
    }
  }
}
