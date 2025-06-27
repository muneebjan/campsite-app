import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';

final campsiteFilterProvider = StateNotifierProvider<CampsiteFilterController, CampsiteFilter>((ref) {
  return CampsiteFilterController();
});

class CampsiteFilterController extends StateNotifier<CampsiteFilter> {
  CampsiteFilterController() : super(const CampsiteFilter());

  void updateSearch(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  void toggleFilter(FilterType type, bool selected) {
    switch (type) {
      case FilterType.closeToWater:
        state = state.copyWith(isCloseToWater: selected ? true : false);
        break;
      case FilterType.campfire:
        state = state.copyWith(isCampFireAllowed: selected ? true : false);
        break;
      case FilterType.english:
        final language = [...state.selectedLanguages];
        selected ? language.add('en') : language.remove('en');
        state = state.copyWith(selectedLanguages: language);
        break;
      case _:
        break;
    }
  }

  void clearAll() {
    state = const CampsiteFilter();
  }
}
