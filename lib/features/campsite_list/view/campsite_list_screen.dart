import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_card.dart';

class CampsiteListScreen extends ConsumerWidget {
  const CampsiteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campsiteAsync = ref.watch(campsiteListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Campsites')),
      body: campsiteAsync.when(
        data: (campsites) {
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final campsite = campsites[index];
              return CampsiteCard(campsite: campsite);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}
