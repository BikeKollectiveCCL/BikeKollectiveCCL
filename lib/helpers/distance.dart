import 'dart:math';

double radiansFromDegrees(double degrees) {
  return degrees * pi / 180;
}

double getDistance(double latAd, double lonAd, double latBd, double lonBd) {
  double latA = radiansFromDegrees(latAd);
  double lonA = radiansFromDegrees(lonAd);
  double latB = radiansFromDegrees(latBd);
  double lonB = radiansFromDegrees(lonBd);
  final double dlon = lonB - lonA;
  final double dlat = latB - latA;
  final double a =
      pow(sin(dlat / 2), 2) + cos(latA) * cos(latB) * pow(sin(dlon / 2), 2);
  final double c = 2 * asin(sqrt(a));
  final double radiusMeters = 6371000.0;
  return c * radiusMeters;
}
