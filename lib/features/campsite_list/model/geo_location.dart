import 'package:json_annotation/json_annotation.dart';

part 'geo_location.g.dart';

@JsonSerializable()
class GeoLocation {
  final double lat;

  @JsonKey(name: 'long')
  final double lng;

  //TODO: geo-location needs to be fixed
  GeoLocation({
    required this.lat,
    required this.lng,
  });

  factory GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);
  Map<String, dynamic> toJson() => _$GeoLocationToJson(this);
}
