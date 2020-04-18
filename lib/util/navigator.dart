import 'package:flutter/material.dart';
import 'package:netfilm/model/cast.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/model/move.dart';
import 'package:netfilm/util/utils.dart';
import 'package:netfilm/widgets/actor_detail/actor_detail.dart';
import 'package:netfilm/widgets/media_details/media_detail.dart';
import 'package:netfilm/widgets/favorite/favorite_screen.dart';
import 'package:netfilm/widgets/play/play_screen.dart';
import 'package:netfilm/widgets/search/search_page.dart';

import 'mediaproviders.dart';

goToMovieDetails(
    BuildContext context, MediaItem movie, MediaProvider provider) {
  _pushWidgetWithFade(context, MediaDetailScreen(movie, provider));
}

goToMoviePlay(BuildContext context, Movie movie, MediaItem mediaItem) {
  if (movie.url != null && movie.url.contains(".mp4")) {
    _pushWidgetWithFade(context, PlayScreen(movie, mediaItem));
  } else {
    launchUrl(movie.url);
  }
}

goToActorDetails(BuildContext context, Actor actor, MediaProvider provider) {
  _pushWidgetWithFade(context, ActorDetailScreen(actor, provider));
}

goToSearch(BuildContext context, MediaProvider provider) {
  _pushWidgetWithFade(context, SearchScreen(provider));
}

goToFavorites(
    BuildContext context, MediaType mediaType, MediaProvider provider) {
  _pushWidgetWithFade(context, FavoriteScreen(mediaType, provider));
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
