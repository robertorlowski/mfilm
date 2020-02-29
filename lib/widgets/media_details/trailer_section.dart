import 'package:flutter/material.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/widgets/media_details/trailer_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TrailerSection extends StatelessWidget {
  final List<Video> _video;

  TrailerSection(this._video);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 0, 4),
          child: Text(
            "Trailers",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Center(
          child: Container(
            width: 390,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: CarouselSlider(
              scrollDirection: Axis.horizontal,
              aspectRatio: 16 / 9,
              autoPlay: false,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              viewportFraction: 0.99,
              pauseAutoPlayOnTouch: Duration(seconds: 5),
              items: _video.map(
                (video) {
                  return Container(
                    child: TrailerCard(video),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
