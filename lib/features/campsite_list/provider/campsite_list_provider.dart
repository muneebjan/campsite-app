import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/core/api/api_client.dart';
import 'package:camping_site/features/campsite_list/data/campsite_repository.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/campsite_list/controller/campsite_list_controller.dart';

// Provides a singleton of the ApiClient
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Provides a singleton of the CampsiteRepository
final campsiteRepositoryProvider = Provider<CampsiteRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CampsiteRepository(apiClient: apiClient);
});

// FutureProvider that fetches the list of campsites
final campsiteListProvider = FutureProvider<List<Campsite>>((ref) async {
  final repo = ref.watch(campsiteRepositoryProvider);
  return repo.fetchCampsites();
});

final filteredCampsiteListProvider = Provider<List<Campsite>>((ref) {
  final filter = ref.watch(campsiteFilterProvider);
  final campsiteAsync = ref.watch(campsiteListProvider);

  return campsiteAsync.maybeWhen(
    data: (campsites) {
      return campsites.where((c) {
        final matchesWater = filter.isCloseToWater == null || c.closeToWater == filter.isCloseToWater;
        final matchesCampfire = filter.isCampFireAllowed == null || c.campFireAllowed == filter.isCampFireAllowed;
        final matchesLanguages =
            filter.selectedLanguages.isEmpty || filter.selectedLanguages.any((lang) => c.hostLanguages.contains(lang));
        final matchesMinPrice = filter.minPrice == null || c.pricePerNight >= filter.minPrice!;
        final matchesMaxPrice = filter.maxPrice == null || c.pricePerNight <= filter.maxPrice!;
        final matchesKeyword =
            filter.searchKeyword.isEmpty || c.label.toLowerCase().contains(filter.searchKeyword.toLowerCase());

        return matchesWater &&
            matchesCampfire &&
            matchesLanguages &&
            matchesMinPrice &&
            matchesMaxPrice &&
            matchesKeyword;
      }).toList();
    },
    orElse: () => [],
  );
});
