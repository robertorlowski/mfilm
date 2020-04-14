import 'package:flutter/material.dart';
import 'package:mfilm/model/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerCard extends StatefulWidget {
  final List<Video> _video;
  final bool _autoPlay;

  TrailerCard(this._video, this._autoPlay);

  @override
  TrailerCardState createState() => TrailerCardState();
}

class TrailerCardState extends State<TrailerCard> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget._video[0].key,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: widget._autoPlay,
          hideThumbnail: false,
          disableDragSeek: true,
          loop: false,
          isLive: false,
          forceHideAnnotation: true,
          forceHD: false,
          enableCaption: true,
        ))
      ..addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.black,
        onReady: () {},
      ),
    ]);
  }

  void listener() {
    setState(() {});
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
