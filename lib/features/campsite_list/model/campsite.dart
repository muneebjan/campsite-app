import 'package:json_annotation/json_annotation.dart';

part 'campsite.g.dart';

@JsonSerializable()
class Campsite {
  final String id;
  final String label;
  final String geoLocation;
  final String country;
  final bool closeToWater;
  final bool campFireAllowed;
  final String hostLanguage;
  final double pricePerNight;
  final String photo;

  Campsite({
    required this.id,
    required this.label,
    required this.geoLocation,
    required this.country,
    required this.closeToWater,
    required this.campFireAllowed,
    required this.hostLanguage,
    required this.pricePerNight,
    required this.photo,
  });

  // JSON deserialization
  factory Campsite.fromJson(Map<String, dynamic> json) => _$CampsiteFromJson(json);

  // JSON serialization
  Map<String, dynamic> toJson() => _$CampsiteToJson(this);
}
