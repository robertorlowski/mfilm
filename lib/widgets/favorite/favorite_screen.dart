import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/widgets/component/toggle_theme_widget.dart';
import 'package:mfilm/widgets/media_list/media_list_item.dart';
import 'package:scoped_model/scoped_model.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        actions: <Widget>[ToggleThemeButton()],
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) =>
            _FavoriteList(model.favoriteMovies),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final List<MediaItem> _media;

  const _FavoriteList(this._media, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _media.length == 0
        ? Center(child: Text("You have no favorites yet!"))
        : ListView.builder(
            itemCount: _media.length,
            itemBuilder: (BuildContext context, int index) {
              return MediaListItem(_media[index]);
            });
  }
}
