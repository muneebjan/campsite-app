import 'package:camping_site/features/campsite_list/model/geo_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'campsite.g.dart';

@JsonSerializable()
class Campsite {
  final String id;
  final String label;
  final String photo;
  final GeoLocation geoLocation;

  @JsonKey(name: 'isCloseToWater')
  final bool closeToWater;

  @JsonKey(name: 'isCampFireAllowed')
  final bool campFireAllowed;

  final List<String> hostLanguages;
  final double pricePerNight;

  Campsite({
    required this.id,
    required this.label,
    required this.photo,
    required this.geoLocation,
    required this.closeToWater,
    required this.campFireAllowed,
    required this.hostLanguages,
    required this.pricePerNight,
  });

  factory Campsite.fromJson(Map<String, dynamic> json) {
    // Convert price from cents to euros
    json = Map<String, dynamic>.from(json);
    if (json['pricePerNight'] != null) {
      json['pricePerNight'] = (json['pricePerNight'] as num) / 100;
    }
    json['geoLocation'] = GeoLocation.generateRandom(json['id'].toString()).toJson();
    return _$CampsiteFromJson(json);
  }
  Map<String, dynamic> toJson() => _$CampsiteToJson(this);
}
