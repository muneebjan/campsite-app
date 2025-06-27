import 'package:camping_site/features/campsite_list/controller/campsite_list_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/campsite_list/model/geo_location.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';

class _FakeFilterController extends CampsiteFilterController {
  _FakeFilterController(CampsiteFilter state) {
    this.state = state;
  }
}

void main() {
  test('filteredCampsiteListProvider filters by searchKeyword', () async {
    final mockCampsites = [
      Campsite(
        id: '1',
        label: 'River Bend',
        geoLocation: GeoLocation(lat: 45.0, lng: 7.0),
        closeToWater: true,
        campFireAllowed: false,
        hostLanguages: ['en'],
        pricePerNight: 30.0,
        photo: '',
      ),
      Campsite(
        id: '2',
        label: 'Forest Hideout',
        geoLocation: GeoLocation(lat: 48.0, lng: 2.0),
        closeToWater: false,
        campFireAllowed: true,
        hostLanguages: ['fr'],
        pricePerNight: 25.0,
        photo: '',
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        campsiteListProvider.overrideWith((ref) async => mockCampsites),
        campsiteFilterProvider.overrideWith((ref) => _FakeFilterController(CampsiteFilter(searchKeyword: 'river'))),
      ],
    );

    await container.read(campsiteListProvider.future);

    final filtered = container.read(filteredCampsiteListProvider);

    expect(filtered.length, 1);
    expect(filtered.first.label, contains('River'));
  });
}
