import 'package:camping_site/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({
    super.key,
    required this.markers,
    required this.initialPosition,
  });

  final List<Marker> markers;
  final LatLng initialPosition;

  @override
  Widget build(BuildContext context) {
    try {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 7,
        ),
        markers: Set<Marker>.from(markers),
        onMapCreated: (GoogleMapController controller) {
        },
      );
    } catch (e) {
      return Center(
        child: Text(
          'Failed to load map. Please check your API key or try again later.',
          style: TextStyle(color: AppColors.secondaryDark, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}