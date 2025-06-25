import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_card.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';

class CampsiteListScreen extends ConsumerWidget {
  const CampsiteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(campsiteFilterProvider);
    final filterNotifier = ref.read(campsiteFilterProvider.notifier);
    final campsiteAsync = ref.watch(campsiteListProvider);
    final filteredCampsites = ref.watch(filteredCampsiteListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Campsites')),
      body: campsiteAsync.when(
        data: (_) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Chips
                Wrap(
                  spacing: 10,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search by name',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        filterNotifier.state = filterNotifier.state.copyWith(searchKeyword: value);
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Min Price (€)'),
                            onChanged: (value) {
                              final minPrice = double.tryParse(value);
                              filterNotifier.state = filterNotifier.state.copyWith(minPrice: minPrice);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Max Price (€)'),
                            onChanged: (value) {
                              final maxPrice = double.tryParse(value);
                              filterNotifier.state = filterNotifier.state.copyWith(maxPrice: maxPrice);
                            },
                          ),
                        ),
                      ],
                    ),

                    FilterChip(
                      label: const Text('Close to Water'),
                      selected: filter.isCloseToWater == true,
                      onSelected: (selected) {
                        filterNotifier.state = filter.copyWith(isCloseToWater: selected ? true : null);
                      },
                    ),
                    FilterChip(
                      label: const Text('Campfire Allowed'),
                      selected: filter.isCampFireAllowed == true,
                      onSelected: (selected) {
                        filterNotifier.state = filter.copyWith(isCampFireAllowed: selected ? true : null);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('Host Languages:'),
                Wrap(
                  spacing: 8,
                  children: ['en', 'de', 'fr', 'es'].map((lang) {
                    return FilterChip(
                      label: Text(lang),
                      selected: filter.selectedLanguages.contains(lang),
                      onSelected: (selected) {
                        final updated = [...filter.selectedLanguages];
                        if (selected) {
                          updated.add(lang);
                        } else {
                          updated.remove(lang);
                        }
                        filterNotifier.state = filter.copyWith(selectedLanguages: updated);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),

                // Clear Filters Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      filterNotifier.state = const CampsiteFilter();
                    },
                    icon: const Icon(Icons.clear),
                    label: const Text("Clear Filters"),
                  ),
                ),

                const Divider(),

                // Filtered List
                Expanded(
                  child: filteredCampsites.isEmpty
                      ? const Center(child: Text('No campsites found.'))
                      : ListView.builder(
                          itemCount: filteredCampsites.length,
                          itemBuilder: (context, index) {
                            final campsite = filteredCampsites[index];
                            return CampsiteCard(campsite: campsite);
                          },
                        ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}
