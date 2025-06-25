import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/core/api/api_client.dart';
import 'package:camping_site/features/campsite_list/data/campsite_repository.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';

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

final campsiteFilterProvider = StateProvider<CampsiteFilter>((ref) {
  return const CampsiteFilter();
});

final filteredCampsiteListProvider = Provider<List<Campsite>>((ref) {
  final filter = ref.watch(campsiteFilterProvider);
  final campsitesAsync = ref.watch(campsiteListProvider);

  return campsitesAsync.maybeWhen(
    data: (campsites) {
      return campsites.where((campsite) {
        final matchesWater = filter.isCloseToWater == null ||
            campsite.closeToWater == filter.isCloseToWater;

        final matchesCampfire = filter.isCampFireAllowed == null ||
            campsite.campFireAllowed == filter.isCampFireAllowed;

        final matchesLanguage = filter.selectedLanguages.isEmpty ||
            campsite.hostLanguages
                .any((lang) => filter.selectedLanguages.contains(lang));

        return matchesWater && matchesCampfire && matchesLanguage;
      }).toList();
    },
    orElse: () => [],
  );
});
