import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CampsiteDetailScreen extends ConsumerWidget {
  final String campsiteId;

  const CampsiteDetailScreen({super.key, required this.campsiteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCampsites = ref.watch(campsiteListProvider);

    return asyncCampsites.when(
      data: (campsites) {
        final campsite = campsites.firstWhere((c) => c.id == campsiteId, orElse: () => throw Exception('Not found'));

        return Scaffold(
          appBar: AppBar(title: Text(campsite.label)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              CachedNetworkImage(imageUrl: campsite.photo, height: 200, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(
                'Price: €${campsite.pricePerNight.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Close to water: ${campsite.closeToWater ? 'Yes' : 'No'}'),
              Text('Campfire allowed: ${campsite.campFireAllowed ? 'Yes' : 'No'}'),
              Text('Host languages: ${campsite.hostLanguages.join(', ')}'),
              Text('Latitude: ${campsite.geoLocation.lat}'),
              Text('Longitude: ${campsite.geoLocation.lng}'),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
