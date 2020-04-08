import 'package:flutter/material.dart';
import 'package:mfilm/model/cast.dart';
import 'package:mfilm/util/mediaproviders.dart';
import 'package:mfilm/widgets/media_details/cast_card.dart';

class CastSection extends StatelessWidget {
  final List<Actor> _cast;
  final MediaProvider _provider;

  CastSection(this._cast, this._provider);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Cast",
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 8.0,
        ),
        Container(
          height: 140.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _cast
                .map((Actor actor) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CastCard(actor, _provider),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
