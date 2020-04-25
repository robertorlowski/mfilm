import 'package:flutter/material.dart';
import 'package:netfilm/model/app_model.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/util/mediaproviders.dart';
import 'package:netfilm/util/navigator.dart';
import 'package:netfilm/widgets/component/text_bubble.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaListItem extends StatelessWidget {
  MediaListItem(this._picture, this._mediaProvider);

  final MediaItem _picture;
  final MediaProvider _mediaProvider;

  Widget _getTitleSection(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => Container(
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(_picture.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Colors.grey[200], fontSize: 17)),
                        ),
                      ],
                    ),
                  ),
                  TextBubble(
                    _picture.getReleaseYear().toString(),
                    backgroundColor: Color(0xffF47663),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  TextBubble(
                    _picture.voteAverage.toString(),
                    backgroundColor: Color(0xffF47663),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Container(
                      child: InkWell(
                    onTap: () => model.toggleFavorites(_picture),
                    child: Icon(
                      model.isItemFavorite(_picture)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 22.0,
                      color: Colors.grey[200],
                    ),
                  )),
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
                onTap: () =>
                    goToMovieDetails(context, _picture, _mediaProvider),
                child: Stack(
                  children: <Widget>[
                    Hero(
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/placeholder.jpg",
                        image: (_picture.backdropPath != ""
                            ? _picture.getBackDropUrl()
                            : _picture.getPosterUrl()),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 250.0,
                        fadeInDuration: Duration(milliseconds: 50),
                      ),
                      tag: "Movie-Tag-${_picture.id}",
                    ),
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0, 210, 0, 0),
                      child: Container(
                          height: 40,
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
