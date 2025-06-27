import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CampsiteDetailLocationWidget extends StatelessWidget {
  const CampsiteDetailLocationWidget({
    super.key,
    required double itemSpacing,
    required double iconSize,
    required double containerRadius,
    required this.campsite,
  }) : _itemSpacing = itemSpacing,
       _iconSize = iconSize,
       _containerRadius = containerRadius;

  final double _itemSpacing;
  final double _iconSize;
  final double _containerRadius;
  final Campsite campsite;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.location,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
        ),
        SizedBox(height: _itemSpacing / 2),
        Row(
          children: [
            Icon(Icons.location_on, size: _iconSize, color: AppColors.secondaryDark),
            SizedBox(width: _itemSpacing / 2),
            Text('Lat: ${campsite.geoLocation.lat.toStringAsFixed(4)}', style: const TextStyle(fontSize: 14)),
            SizedBox(width: _itemSpacing),
            Text('Lng: ${campsite.geoLocation.lng.toStringAsFixed(4)}', style: const TextStyle(fontSize: 14)),
          ],
        ),
        SizedBox(height: _itemSpacing),
        Container(
          height: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(_containerRadius), color: AppColors.background),
          child: Center(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(campsite.geoLocation.lat, campsite.geoLocation.lng),
                zoom: 12,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('campsite-marker'),
                  position: LatLng(campsite.geoLocation.lat, campsite.geoLocation.lng),
                  infoWindow: InfoWindow(title: campsite.label),
                ),
              },
              mapType: MapType.normal,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
        ),
      ],
    );
  }
}
