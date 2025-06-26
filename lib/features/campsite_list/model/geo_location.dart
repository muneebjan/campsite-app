import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'geo_location.g.dart';

@JsonSerializable()
class GeoLocation {
  final double lat;

  @JsonKey(name: 'long')
  final double lng;

  GeoLocation({required this.lat, required this.lng});
  // generate valid random coordinates within Deutschland
  // because api coordinates are invalid
  factory GeoLocation.generateRandom(String seed) {
    final random = Random(seed.hashCode);
    return GeoLocation(
      lat: 47.0 + random.nextDouble() * 8.0,  // 47° to 55° N (Germany's latitude range)
      lng: 5.0 + random.nextDouble() * 10.0,  // 5° to 15° E (Germany's longitude range)
    );
  }

  factory GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeoLocationToJson(this);
}
