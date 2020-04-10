import 'package:flutter/material.dart';
import 'package:mfilm/model/video.dart';
import 'package:mfilm/widgets/media_details/trailer_card.dart';

class TrailerSection extends StatelessWidget {
  final List<Video> _video;

  TrailerSection(this._video);

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
                "Trailers",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.height - 20,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _video == null
                  ? Image.asset("assets/placeholder.jpg")
                  : TrailerCard(_video),
            )

            /*
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width - 20,
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: CarouselSlider(
            scrollDirection: Axis.horizontal,
            aspectRatio: 16 / 9,
            autoPlay: false,
            viewportFraction: 0.99,
            items: _video.map(
              (video) {
                return Container(
                  child: TrailerCard(video),
                );
              },
            ).toList(),
          ),
        ),
        */
          ],
        );
      },
    );
  }
}
