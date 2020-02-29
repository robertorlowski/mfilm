import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/move.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class PlayScreen extends StatefulWidget {
  final Movie movie;
  final MediaItem mediaItem;

  PlayScreen(this.movie, this.mediaItem);

  @override
  PlayScreenState createState() {
    return PlayScreenState();
  }
}

class PlayScreenState extends State<PlayScreen> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  bool enterScrean = false;
  bool exitScrean = false;

  @override
  void initState() {
    super.initState();
    print(widget.movie.url);
    videoPlayerController = VideoPlayerController.network(widget.movie.url);
    videoPlayerController.addListener(listenerVideoPlayer);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: true,
      allowMuting: true,
      startAt: new Duration(seconds: 0),
      fullScreenByDefault: false,
      showControlsOnInitialize: true,
      placeholder:
          Center(child: Image.network(widget.mediaItem.getBackDropUrl())),
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    chewieController.addListener(listenerChewieController);
  }

  void listenerChewieController() {
    if (chewieController.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      AutoOrientation.landscapeMode();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      AutoOrientation.portraitMode();
      if (!exitScrean) {
        exitScrean = true;
        Navigator.pop(context);
      }
    }
  }

  void listenerVideoPlayer() {
    if (chewieController == null) {
      return;
    }
    if (!chewieController.isFullScreen &&
        !enterScrean &&
        videoPlayerController.value.isPlaying) {
      enterScrean = true;
      chewieController.enterFullScreen();
    }
    setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AutoOrientation.portraitMode();

    if (videoPlayerController != null) {
      videoPlayerController.removeListener(listenerVideoPlayer);
      videoPlayerController.dispose();
    }
    if (chewieController != null) {
      chewieController.removeListener(listenerChewieController);
      chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new NestedScrollView(
            controller: null,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  title: new Text(widget.mediaItem.title),
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                ),
              ];
            },
            body: chewieController == null
                ? Container(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Chewie(
                          controller: chewieController,
                        )
                      ])));
  }
}
