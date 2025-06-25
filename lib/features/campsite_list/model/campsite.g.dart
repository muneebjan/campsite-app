// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campsite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Campsite _$CampsiteFromJson(Map<String, dynamic> json) => Campsite(
  id: json['id'] as String,
  label: json['label'] as String,
  geoLocation: json['geoLocation'] as String,
  country: json['country'] as String,
  closeToWater: json['closeToWater'] as bool,
  campFireAllowed: json['campFireAllowed'] as bool,
  hostLanguage: json['hostLanguage'] as String,
  pricePerNight: (json['pricePerNight'] as num).toDouble(),
  photo: json['photo'] as String,
);

Map<String, dynamic> _$CampsiteToJson(Campsite instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'geoLocation': instance.geoLocation,
  'country': instance.country,
  'closeToWater': instance.closeToWater,
  'campFireAllowed': instance.campFireAllowed,
  'hostLanguage': instance.hostLanguage,
  'pricePerNight': instance.pricePerNight,
  'photo': instance.photo,
};
