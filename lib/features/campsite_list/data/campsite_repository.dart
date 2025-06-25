import 'package:camping_site/core/api/api_client.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';

class CampsiteRepository {
  final ApiClient apiClient;

  CampsiteRepository({required this.apiClient});

  Future<List<Campsite>> fetchCampsites() async {
    final rawData = await apiClient.getCampsitesRaw();

    return rawData.map((json) {
      return Campsite.fromJson(json as Map<String, dynamic>);
    }).toList();
  }
}
