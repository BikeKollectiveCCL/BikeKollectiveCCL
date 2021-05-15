import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import '../models/bikeDTO.dart';
import '../helpers/tags.dart';

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

Widget showTags(BuildContext context, BikeDTO thisBike) {
  double _fontSize = 14;
  return Tags(
    key: _tagStateKey,
    itemCount: availableTags.length, // required
    itemBuilder: (int index) {
      final tag = availableTags[index];
      return ItemTags(
        // Each ItemTags must contain a Key. Keys allow Flutter to
        // uniquely identify widgets.
        key: Key(index.toString()),
        active: false,
        color: Colors.white,
        activeColor: Colors.blueAccent,
        index: index, // required
        title: tag,
        textStyle: TextStyle(
          fontSize: _fontSize,
        ),
        combine: ItemTagsCombine.withTextBefore,
        onPressed: (tag) {
          print(tag);
          thisBike.tags[tag.title] = tag.active;
        },
        onLongPressed: (tag) => print(tag),
      );
    },
  );
}
