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
