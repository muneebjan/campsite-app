// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) => GeoLocation(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['long'] as num).toDouble(),
);

Map<String, dynamic> _$GeoLocationToJson(GeoLocation instance) =>
    <String, dynamic>{'lat': instance.lat, 'long': instance.lng};
