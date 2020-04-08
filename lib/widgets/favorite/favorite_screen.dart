import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/component/toggle_theme_widget.dart';
import 'package:mfilm/widgets/media_list/media_list_item.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoriteScreen extends StatelessWidget {
  final MediaType _mediaType;
  final MediaProvider _mediaProvider;

  FavoriteScreen(this._mediaType, this._mediaProvider);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        actions: <Widget>[ToggleThemeButton()],
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => _FavoriteList(
            model.favoriteMovies(this._mediaType), _mediaProvider),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final List<MediaItem> _media;
  final MediaProvider _mediaProvider;

  const _FavoriteList(this._media, this._mediaProvider, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _media.length == 0
        ? Center(child: Text("You have no favorites yet!"))
        : ListView.builder(
            itemCount: _media.length,
            itemBuilder: (BuildContext context, int index) {
              return MediaListItem(_media[index], _mediaProvider);
            });
  }
}
