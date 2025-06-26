import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/map_feature/widgets/map_widget.dart';

class CampsiteMapScreen extends ConsumerWidget {
  const CampsiteMapScreen({super.key});

  static const LatLng initialPosition = LatLng(37.7749, -122.4194); // Fallback

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCampsites = ref.watch(campsiteListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: asyncCampsites.when(
        data: (campsites) {
          final markers = _buildMarkers(campsites);

          return SizedBox.expand(
            child: GoogleMapWidget(markers: markers, initialPosition: initialPosition),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading campsites: $err')),
      ),
    );

  }

  List<Marker> _buildMarkers(List<Campsite> campsites) {
    return campsites.map((campsite) {
      return Marker(
        markerId: MarkerId(campsite.id),
        position: LatLng(
          campsite.geoLocation.lat,
          campsite.geoLocation.lng,
        ),
        infoWindow: InfoWindow(
          title: campsite.label,
          snippet: '€${campsite.pricePerNight.toStringAsFixed(2)} / night',
        ),
      );
    }).toList();
  }
}
