import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:camping_site/core/api/api_client.dart';
import 'package:camping_site/features/campsite_list/data/campsite_repository.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';

import 'campsite_list_repository.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late CampsiteRepository repository;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    repository = CampsiteRepository(apiClient: mockApiClient);
  });

  test('returns a list of Campsite when ApiClient returns valid data', () async {
    final rawData = [
      {
        "createdAt": "2022-09-11T14:25:09.496Z",
        "label": "quibusdam",
        "photo": "http://loremflickr.com/640/480",
        "geoLocation": {
          "lat": 96060.37,
          "long": 72330.52
        },
        "isCloseToWater": true,
        "isCampFireAllowed": false,
        "hostLanguages": [
          "en",
          "de"
        ],
        "pricePerNight": 78508.23,
        "suitableFor": [],
        "id": "1"
      },
    ];

    when(mockApiClient.getCampsitesRaw()).thenAnswer((_) async => rawData);

    final result = await repository.fetchCampsites();

    expect(result, isA<List<Campsite>>());
    expect(result.length, 1);
    expect(result.first.label, "quibusdam");
  });

  test('throws an exception when ApiClient throws', () async {
    when(mockApiClient.getCampsitesRaw()).thenThrow(Exception("Network error"));

    expect(repository.fetchCampsites(), throwsException);
  });
}
