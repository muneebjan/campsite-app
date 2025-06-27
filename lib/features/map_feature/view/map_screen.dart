import 'package:camping_site/core/common_widgets/campsite_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/map_feature/widgets/map_widget.dart';

class CampsiteMapScreen extends ConsumerWidget {
  const CampsiteMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCampsites = ref.watch(campsiteListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CampSiteAppBar(theme: theme),
      body: asyncCampsites.when(
        data: (campsites) {
          final markers = _buildMarkers(campsites);
          final LatLng initialPosition = markers.isNotEmpty ? markers.first.position : const LatLng(48.2740, 9.4031);
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
        position: LatLng(campsite.geoLocation.lat, campsite.geoLocation.lng),
        infoWindow: InfoWindow(title: campsite.label, snippet: '€${campsite.pricePerNight.toStringAsFixed(2)} / night'),
      );
    }).toList();
  }
}
