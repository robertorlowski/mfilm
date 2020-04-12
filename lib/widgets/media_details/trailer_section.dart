import 'package:flutter/material.dart';
import 'package:mfilm/i18/app_localizations.dart';
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
                AppLocalizations.of(context).translate("trailer"),
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
          ],
        );
      },
    );
  }
}
