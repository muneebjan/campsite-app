import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:camping_site/core/api/api_client.dart';
import 'package:camping_site/features/campsite_list/data/campsite_repository.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';

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
