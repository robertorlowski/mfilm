import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaListItem extends StatelessWidget {
  MediaListItem(this.picture);

  final MediaItem picture;

  Widget _getTitleSection(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => Container(
              padding: EdgeInsets.fromLTRB(10.0, 10, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(picture.title,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(
                                      color: Colors.grey[200], fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[],
                  ),
                  Container(
                    width: 14.0,
                  ),
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () => model.toggleFavorites(picture),
                          child: Icon(
                            model.isItemFavorite(picture)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 20.0,
                            color: Colors.grey[200],
                          ),
                        )
                      ]),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => Card(
              margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
              child: InkWell(
                onTap: () => goToMovieDetails(context, picture),
                child: Stack(
                  children: <Widget>[
                    Hero(
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/placeholder.jpg",
                        image: picture.getBackDropUrl(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250.0,
                        fadeInDuration: Duration(milliseconds: 50),
                      ),
                      tag: "Movie-Tag-${picture.id}",
                    ),
                    /*
                    new Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Icon(model.isItemFavorite(picture)
                                ? Icons.favorite
                                : Icons.favorite_border),
                            color: Colors.white,
                            onPressed: () => model.toggleFavorites(picture))),
                    */
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0, 210, 0, 0),
                      child: Container(
                          height: 42,
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.5)),
                          child: _getTitleSection(context)),
                    ),
                  ],
                ),
              ),
            ));
  }
}
