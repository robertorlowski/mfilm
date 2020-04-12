import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/searchresult.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/util/navigator.dart';
import 'package:mfilm/util/styles.dart';

class SearchItemCard extends StatelessWidget {
  final SearchResult item;
  final MediaProvider provider;

  SearchItemCard(this.item, this.provider);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Row(
          children: <Widget>[
            FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 100.0,
                height: 150.0,
                placeholder: "assets/placeholder.jpg",
                image: item.imageUrl),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          AppLocalizations.of(context)
                              .translate(item.mediaTypeName)
                              .toUpperCase(),
                          style: TextStyle(color: colorAccent)),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.subtitle, style: captionStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleTap(BuildContext context) {
    switch (item.mediaType) {
      case "db":
        goToMovieDetails(context, item.asMovie(MediaType.db), provider);
        return;
      case "video":
      case "movie":
        goToMovieDetails(context, item.asMovie(MediaType.video), provider);
        return;
      case "person":
        goToActorDetails(context, item.asActor(), provider);
    }
  }
}
