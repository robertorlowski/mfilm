import 'package:flutter/material.dart';
import 'package:mfilm/model/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerCard extends StatefulWidget {
  final Video _video;

  TrailerCard(this._video);

  @override
  TrailerCardState createState() => TrailerCardState();
}

class TrailerCardState extends State<TrailerCard> {
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget._video.key,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: false,
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
    return Container(
      child: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.black,
        onReady: () {
          _isPlayerReady = true;
        },
      ),
    );
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
