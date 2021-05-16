import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget ratingDisplay(double rating, double size) {
  return RatingBarIndicator(
    rating: rating,
    itemBuilder: (context, index) => Icon(
      Icons.star,
      color: Colors.amber,
    ),
    itemCount: 5,
    itemSize: size,
    direction: Axis.horizontal,
  );
}
