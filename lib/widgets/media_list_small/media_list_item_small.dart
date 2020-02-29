import 'package:flutter/material.dart';
import 'package:mfilm/model/app_model.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/util/styles.dart';
import 'package:mfilm/widgets/component/text_bubble.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaListSmallItem extends StatelessWidget {
  MediaListSmallItem(this.picture);

  final MediaItem picture;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
              child: InkWell(
                onTap: () => goToMovieDetails(context, picture),
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
                          children: <Widget>[
                            SizedBox(
                              width: 10,
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
                            SizedBox(
                              width: 50,
                            ),
                            Container(
                                height: 42,
                                child: InkWell(
                                  onTap: () => model.toggleFavorites(picture),
                                  child: Icon(
                                    model.isItemFavorite(picture)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20.0,
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
