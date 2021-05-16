import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import '../models/bikeDTO.dart';
import '../models/bike.dart';
import '../helpers/tags.dart';

final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

Widget editTags(BuildContext context, Bike thisBike) {
  List<String> setTags = [];
  thisBike.tags.forEach((key, value) {
    if (value) {
      setTags.add(key);
    }
  });
  return Tags(
    key: _tagStateKey,
    itemCount: availableTags.length, // required
    itemBuilder: (int index) {
      final tag = availableTags[index];
      return ItemTags(
        // Each ItemTags must contain a Key. Keys allow Flutter to
        // uniquely identify widgets.
        key: Key(index.toString()),
        active: setTags.contains(tag),
        color: Colors.white,
        activeColor: Colors.blueAccent,
        index: index, // required
        title: tag,
        textStyle: TextStyle(
          fontSize: 14,
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

Widget addTags(BuildContext context, BikeDTO thisBike) {
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

Widget loadTags(BuildContext context, Map currentTags) {
  // convert Map to list of strings for tags that are set
  List<String> tags = [];
  currentTags.forEach((key, value) {
    if (value) {
      tags.add(key);
    }
  });
  double _fontSize = 14;
  return Tags(
    key: _tagStateKey,
    itemCount: tags.length, // required
    itemBuilder: (int index) {
      final tag = tags[index];

      return ItemTags(
        // Each ItemTags must contain a Key. Keys allow Flutter to
        // uniquely identify widgets.
        key: Key(index.toString()),
        active: true,
        pressEnabled: false,
        activeColor: Colors.blueAccent,
        index: index, // required
        title: tag,
        textStyle: TextStyle(
          fontSize: _fontSize,
        ),
        combine: ItemTagsCombine.withTextBefore,
        onLongPressed: (tag) => print(tag),
      );
    },
  );
}
