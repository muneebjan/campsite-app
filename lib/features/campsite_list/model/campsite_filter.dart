import 'package:flutter/material.dart';

class CampsiteFilter {
  final bool? isCloseToWater;
  final bool? isCampFireAllowed;
  final List<String> selectedLanguages;
  final double? minPrice;
  final double? maxPrice;
  final String searchKeyword;

  const CampsiteFilter({
    this.isCloseToWater,
    this.isCampFireAllowed,
    this.selectedLanguages = const [],
    this.minPrice,
    this.maxPrice,
    this.searchKeyword = '',
  });

  CampsiteFilter copyWith({
    bool? isCloseToWater,
    bool? isCampFireAllowed,
    List<String>? selectedLanguages,
    double? minPrice,
    double? maxPrice,
    String? searchKeyword,
  }) {
    return CampsiteFilter(
      isCloseToWater: isCloseToWater ?? this.isCloseToWater,
      isCampFireAllowed: isCampFireAllowed ?? this.isCampFireAllowed,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}
enum FilterType {
  hiking,
  camping,
  closeToWater,
  campfire,
  english,
}

extension FilterTypeExtension on FilterType {
  String get displayName {
    return switch (this) {
      FilterType.hiking => 'Hiking',
      FilterType.camping => 'Camping',
      FilterType.closeToWater => 'Close to Water',
      FilterType.campfire => 'Campfire',
      FilterType.english => 'English',
    };
  }

  IconData get icon {
    return switch (this) {
      FilterType.hiking => Icons.directions_walk,
      FilterType.camping => Icons.forest,
      FilterType.closeToWater => Icons.water,
      FilterType.campfire => Icons.fireplace,
      FilterType.english => Icons.language,
    };
  }

  bool appliesTo(CampsiteFilter filter) {
    return switch (this) {
      FilterType.closeToWater => filter.isCloseToWater == true,
      FilterType.campfire => filter.isCampFireAllowed == true,
      FilterType.english => filter.selectedLanguages.contains('en'),
      _ => false,
    };
  }
}