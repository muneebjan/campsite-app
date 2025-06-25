// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campsite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campsite _$CampsiteFromJson(Map<String, dynamic> json) => Campsite(
  id: json['id'] as String,
  label: json['label'] as String,
  photo: json['photo'] as String,
  geoLocation: GeoLocation.fromJson(
    json['geoLocation'] as Map<String, dynamic>,
  ),
  closeToWater: json['isCloseToWater'] as bool,
  campFireAllowed: json['isCampFireAllowed'] as bool,
  hostLanguages: (json['hostLanguages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  pricePerNight: (json['pricePerNight'] as num).toDouble(),
);

Map<String, dynamic> _$CampsiteToJson(Campsite instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'photo': instance.photo,
  'geoLocation': instance.geoLocation,
  'isCloseToWater': instance.closeToWater,
  'isCampFireAllowed': instance.campFireAllowed,
  'hostLanguages': instance.hostLanguages,
  'pricePerNight': instance.pricePerNight,
};
