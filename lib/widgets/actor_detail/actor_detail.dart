import 'dart:async';

import 'package:flutter/material.dart';
import 'package:netfilm/model/cast.dart';
import 'package:netfilm/model/mediaitem.dart';
import 'package:netfilm/util/api_client.dart';
import 'package:netfilm/util/mediaproviders.dart';
import 'package:netfilm/util/styles.dart';
import 'package:netfilm/widgets/component/fitted_circle_avatar.dart';
import 'package:netfilm/widgets/media_list/media_list_item.dart';

class ActorDetailScreen extends StatelessWidget {
  final Actor _actor;
  final ApiClient _apiClient = ApiClient();
  final MediaProvider _mediaProvider;

  ActorDetailScreen(this._actor, this._mediaProvider);

  @override
  Widget build(BuildContext context) {
    var movieFuture = _apiClient.getMoviesForActor(_actor.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: primary,
        body: NestedScrollView(
          body: _buildMoviesSection(movieFuture),
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) =>
                  [_buildAppBar(context, _actor)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      expandedHeight: 230.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 40,
              ),
              Hero(
                  tag: 'Cast-Hero-${actor.id}',
                  child: Container(
                    width: 160.0,
                    height: 160.0,
                    child: FittedCircleAvatar(
                      backgroundImage: NetworkImage(actor.profilePictureUrl),
                    ),
                  )),
              Container(
                height: 8.0,
              ),
              Text(
                actor.name,
                style: whiteBody.copyWith(fontSize: 22.0),
              ),
              Container(
                height: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(Future<List<MediaItem>> future) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    MediaListItem(snapshot.data[index], _mediaProvider),
                itemCount: snapshot.data.length,
              )
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              );
      },
    );
  }
}
