import 'package:flutter/material.dart';
import 'package:mfilm/model/cast.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/move.dart';
import 'package:mfilm/util/utils.dart';
import 'package:mfilm/widgets/actor_detail/actor_detail.dart';
import 'package:mfilm/widgets/media_details/media_detail.dart';
import 'package:mfilm/widgets/favorite/favorite_screen.dart';
import 'package:mfilm/widgets/play/play_screen.dart';
import 'package:mfilm/widgets/search/search_page.dart';

import 'mediaproviders.dart';

goToMovieDetails(BuildContext context, MediaItem movie) {
  MediaProvider provider = MovieProviderVideo();
  _pushWidgetWithFade(context, MediaDetailScreen(movie, provider));
}

goToMoviePlay(BuildContext context, Movie movie, MediaItem mediaItem) {
  if (movie.url.contains(".mp4")) {
    _pushWidgetWithFade(context, PlayScreen(movie, mediaItem));
  } else {
    launchUrl(movie.url);
  }
}

goToActorDetails(BuildContext context, Actor actor) {
  _pushWidgetWithFade(context, ActorDetailScreen(actor));
}

goToSearch(BuildContext context, MediaProvider provider) {
  _pushWidgetWithFade(context, SearchScreen(provider));
}

goToFavorites(BuildContext context) {
  _pushWidgetWithFade(context, FavoriteScreen());
}

_pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return widget;
        }),
  );
}
