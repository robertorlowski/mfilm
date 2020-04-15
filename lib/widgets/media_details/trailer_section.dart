import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
import 'package:mfilm/model/mediaitem.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/widgets/media_details/trailer_card.dart';

class TrailerSection extends StatefulWidget {
  final List<Video> _video;
  final MediaItem _mediaItem;

  TrailerSection(this._video, this._mediaItem);

  @override
  TrailerSectionState createState() => TrailerSectionState();
}

class TrailerSectionState extends State<TrailerSection> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
              child: Text(
                AppLocalizations.of(context).translate("trailer"),
                style: TextStyle(color: Colors.white),
              ),
            ),
            _isPlaying && widget._video != null
                ? Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.height - 20,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: TrailerCard(widget._video, true),
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.height - 20,
                        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Hero(
                          tag: "Movie-Tag-${widget._mediaItem.id}",
                          child: FadeInImage.assetNetwork(
                              fit: BoxFit.fill,
                              height: 210,
                              placeholder: "assets/placeholder.jpg",
                              image: widget._mediaItem.backdropPath != ""
                                  ? widget._mediaItem.getBackDropUrl()
                                  : widget._mediaItem.getPosterUrl()),
                        ),
                      ),
                      widget._video == null
                          ? Container(
                              width: 0,
                              height: 0,
                            )
                          : Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () => _play(),
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )
          ],
        );
      },
    );
  }

  _play() {
    setState(() {
      _isPlaying = true;
    });
  }
}
