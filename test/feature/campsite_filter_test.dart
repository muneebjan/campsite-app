import 'package:camping_site/features/campsite_list/model/geo_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';

void main() {
  // Mock campsite data
  final mockCampsites = [
    Campsite(
      id: '1',
      label: 'Lakeview Retreat',
      geoLocation: GeoLocation(lat: 52.52, lng: 13.405),
      closeToWater: true,
      campFireAllowed: true,
      hostLanguages: ['en', 'de'],
      pricePerNight: 40.0,
      photo: 'https://example.com/photo1.jpg',
    ),
    Campsite(
      id: '2',
      label: 'Forest Hideout',
      geoLocation: GeoLocation(lat: 48.8566, lng: 2.3522),
      closeToWater: false,
      campFireAllowed: false,
      hostLanguages: ['fr'],
      pricePerNight: 25.0,
      photo: 'https://example.com/photo2.jpg',
    ),
    Campsite(
      id: '3',
      label: 'River Bend',
      geoLocation: GeoLocation(lat: 45.0, lng: 7.0),
      closeToWater: true,
      campFireAllowed: false,
      hostLanguages: ['en', 'it'],
      pricePerNight: 55.0,
      photo: 'https://example.com/photo3.jpg',
    ),
  ];

  List<Campsite> applyFilter(CampsiteFilter filter) {
    return mockCampsites.where((camp) {
      if (filter.searchKeyword.isNotEmpty &&
          !camp.label.toLowerCase().contains(filter.searchKeyword.toLowerCase())) {
        return false;
      }

      if (filter.minPrice != null && camp.pricePerNight < filter.minPrice!) {
        return false;
      }

      if (filter.maxPrice != null && camp.pricePerNight > filter.maxPrice!) {
        return false;
      }

      if (filter.isCloseToWater == true && !camp.closeToWater) {
        return false;
      }

      if (filter.isCampFireAllowed == true && !camp.campFireAllowed) {
        return false;
      }

      if (filter.selectedLanguages.isNotEmpty &&
          !filter.selectedLanguages.any((lang) => camp.hostLanguages.contains(lang))) {
        return false;
      }

      return true;
    }).toList();
  }

  group('CampsiteFilter', () {
    test('filters by search keyword', () {
      final filter = CampsiteFilter(searchKeyword: 'lake');
      final results = applyFilter(filter);
      expect(results.length, 1);
      expect(results.first.label, contains('Lakeview'));
    });

    test('filters by price range', () {
      final filter = CampsiteFilter(minPrice: 30.0, maxPrice: 50.0);
      final results = applyFilter(filter);
      expect(results.length, 1);
      expect(results.first.label, 'Lakeview Retreat');
    });

    test('filters by "close to water"', () {
      final filter = CampsiteFilter(isCloseToWater: true);
      final results = applyFilter(filter);
      expect(results.length, 2);
      expect(results.every((c) => c.closeToWater), isTrue);
    });

    test('filters by "campfire allowed"', () {
      final filter = CampsiteFilter(isCampFireAllowed: true);
      final results = applyFilter(filter);
      expect(results.length, 1);
      expect(results.first.label, 'Lakeview Retreat');
    });

    test('filters by host language', () {
      final filter = CampsiteFilter(selectedLanguages: ['fr']);
      final results = applyFilter(filter);
      expect(results.length, 1);
      expect(results.first.label, 'Forest Hideout');
    });

    test('multiple filters work together', () {
      final filter = CampsiteFilter(
        isCloseToWater: true,
        selectedLanguages: ['en'],
      );
      final results = applyFilter(filter);
      expect(results.length, 2); // ✅ Now correct
      expect(results.any((c) => c.label == 'Lakeview Retreat'), isTrue);
      expect(results.any((c) => c.label == 'River Bend'), isTrue);
    });


    test('returns all campsites when no filters applied', () {
      final filter = CampsiteFilter();
      final results = applyFilter(filter);
      expect(results.length, mockCampsites.length);
    });
  });
}
