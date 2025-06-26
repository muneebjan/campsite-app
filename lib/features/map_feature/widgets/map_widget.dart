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
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: markers.isNotEmpty
            ? markers.first.position
            : initialPosition,
        zoom: 7,
      ),
      markers: Set<Marker>.from(markers),
      mapType: MapType.normal,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
    );
  }
}