import 'package:flutter/material.dart';
import 'package:netfilm/model/app_model.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/util/mediaproviders.dart';
import 'package:netfilm/util/navigator.dart';
import 'package:netfilm/util/styles.dart';
import 'package:netfilm/widgets/component/text_bubble.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaListSmallItem extends StatelessWidget {
  MediaListSmallItem(this.picture, this.provider);

  final MediaItem picture;
  final MediaProvider provider;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
              child: InkWell(
                onTap: () => goToMovieDetails(context, picture, provider),
                child: Stack(
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: "assets/placeholder.jpg",
                      image: picture.posterPath == ""
                          ? picture.getBackDropUrl()
                          : picture.getPosterUrl(),
                      fit: BoxFit.cover,
                      width: 160,
                      height: 240.0,
                      fadeInDuration: Duration(milliseconds: 50),
                    ),
                    new Padding(
                      padding: new EdgeInsets.fromLTRB(0, 240, 0, 0),
                      child: Container(
                        decoration: new BoxDecoration(color: primary),
                        width: 160,
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              TextBubble(
                                picture.getReleaseYear().toString(),
                                backgroundColor: Color(0xffF47663),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              TextBubble(
                                picture.voteAverage.toString(),
                                backgroundColor: Color(0xffF47663),
                              ),
                            ]),
                            Container(
                                padding: EdgeInsets.all(5),
                                height: 42,
                                child: InkWell(
                                  onTap: () => model.toggleFavorites(picture),
                                  child: Icon(
                                    model.isItemFavorite(picture)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 24.0,
                                    color: Colors.grey[200],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
