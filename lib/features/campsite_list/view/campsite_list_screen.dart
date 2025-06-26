import 'package:camping_site/core/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_card.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';

class CampsiteListScreen extends ConsumerStatefulWidget {
  const CampsiteListScreen({super.key});

  @override
  ConsumerState<CampsiteListScreen> createState() => _CampsiteListScreenState();
}

class _CampsiteListScreenState extends ConsumerState<CampsiteListScreen> {
  late final TextEditingController _searchController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/icons/camping-tent.svg', height: 32),
            const SizedBox(width: 12),
            Text(
              StringConstants.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.secondaryDark,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final filter = ref.watch(campsiteFilterProvider);
    final filterNotifier = ref.read(campsiteFilterProvider.notifier);
    final campsiteAsync = ref.watch(campsiteListProvider);
    final filteredCampsites = ref.watch(filteredCampsiteListProvider);

    return campsiteAsync.when(
      data: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(child: _buildSearchField(filter, filterNotifier, theme)),
            SliverToBoxAdapter(child: _buildFeaturedSection()),
            SliverToBoxAdapter(child: _buildFilterSection(filter, filterNotifier, theme)),
            SliverToBoxAdapter(child: _buildCampsiteHeader(theme)),
            if (filteredCampsites.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    StringConstants.noCampsitesFound,
                    style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CampsiteCard(campsite: filteredCampsites[index]),
                  childCount: filteredCampsites.length,
                ),
              ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator.adaptive(backgroundColor: AppColors.primary)),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(StringConstants.errorLoading, style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.error)),
        ),
      ),
    );
  }

  Widget _buildSearchField(CampsiteFilter filter, StateController<CampsiteFilter> filterNotifier, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: StringConstants.searchCampsites,
          labelStyle: TextStyle(color: AppColors.secondaryDark.withValues(alpha: 0.8), fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: Icon(Icons.search, color: AppColors.secondaryDark, size: 20),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondaryDark.withValues(alpha: 0.4), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondaryDark.withValues(alpha: 0.4), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.secondaryDark, width: 1.5),
          ),
          filled: true,
          fillColor: AppColors.surface,
          isDense: true,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.secondaryDark, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    _searchController.clear();
                    filterNotifier.state = filter.copyWith(searchKeyword: '');
                  },
                )
              : null,
        ),
        onChanged: (value) => filterNotifier.state = filter.copyWith(searchKeyword: value),
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'assets/images/background.svg',
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppColors.secondaryLight.withValues(alpha: 0.7), BlendMode.darken),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(StringConstants.featuredTitleLine1, style: AppTextStyles.featuredHeader),
                  Text(StringConstants.featuredTitleLine2, style: AppTextStyles.featuredHeader),
                  Text(StringConstants.featuredTitleLine3, style: AppTextStyles.featuredHeader),
                  const SizedBox(height: 8),
                  Container(height: 2, width: 40, color: AppColors.textOnPrimary.withValues(alpha: 0.8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(CampsiteFilter filter, StateController<CampsiteFilter> filterNotifier, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringConstants.discoverByFilters, style: AppTextStyles.titleLarge.copyWith(color: AppColors.secondaryDark)),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final filterType in FilterType.values) _buildFilterChip(filterType, filter, filterNotifier),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              _searchController.clear();
              filterNotifier.state = const CampsiteFilter();
            },
            icon: Icon(Icons.clear, size: 16, color: AppColors.primaryDark),
            label: Text(StringConstants.clearFilters, style: TextStyle(color: AppColors.primaryDark)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCampsiteHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(StringConstants.campingSites, style: AppTextStyles.titleLarge.copyWith(color: AppColors.secondaryDark)),
    );
  }

  Widget _buildFilterChip(
    FilterType filterType,
    CampsiteFilter filter,
    StateController<CampsiteFilter> filterNotifier,
  ) {
    final isSelected = filterType.appliesTo(filter);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(filterType.icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(filterType.displayName, style: TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) => _handleFilterSelection(
          filterType: filterType,
          selected: selected,
          filter: filter,
          filterNotifier: filterNotifier,
        ),
        selectedColor: AppColors.secondaryDark,
        backgroundColor: AppColors.secondaryDark,
        checkmarkColor: Colors.white,
        showCheckmark: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide.none),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  void _handleFilterSelection({
    required FilterType filterType,
    required bool selected,
    required CampsiteFilter filter,
    required StateController<CampsiteFilter> filterNotifier,
  }) {
    switch (filterType) {
      case FilterType.closeToWater:
        filterNotifier.state = filter.copyWith(isCloseToWater: selected ? true : null);
      case FilterType.campfire:
        filterNotifier.state = filter.copyWith(isCampFireAllowed: selected ? true : null);
      case FilterType.english:
        final updated = [...filter.selectedLanguages];
        selected ? updated.add('en') : updated.remove('en');
        filterNotifier.state = filter.copyWith(selectedLanguages: updated);
      case _:
        break;
    }
  }
}
