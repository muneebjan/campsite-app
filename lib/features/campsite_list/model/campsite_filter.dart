class CampsiteFilter {
  final bool? isCloseToWater;
  final bool? isCampFireAllowed;
  final List<String> selectedLanguages;

  const CampsiteFilter({this.isCloseToWater, this.isCampFireAllowed, this.selectedLanguages = const []});

  CampsiteFilter copyWith({bool? isCloseToWater, bool? isCampFireAllowed, List<String>? selectedLanguages}) {
    return CampsiteFilter(
      isCloseToWater: isCloseToWater ?? this.isCloseToWater,
      isCampFireAllowed: isCampFireAllowed ?? this.isCampFireAllowed,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
    );
  }

  bool get isFiltering => isCloseToWater != null || isCampFireAllowed != null || selectedLanguages.isNotEmpty;

  static const empty = CampsiteFilter();
}
