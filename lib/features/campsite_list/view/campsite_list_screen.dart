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
      // backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        title: const Text(
          'Campsites',
          style: TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes shadow
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
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
                    'No campsites found',
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
          child: Text('Failed to load campsites', style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.error)),
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
          labelText: 'Search by name',
          labelStyle: TextStyle(color: AppColors.primary),
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.secondary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.surface,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.primary),
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
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(AppColors.primaryDark.withOpacity(0.7), BlendMode.darken),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Camping Location',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black.withOpacity(0.3), offset: const Offset(1, 1))],
                ),
                textAlign: TextAlign.center,
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
        Text('Discover by filters', style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
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
            icon: Icon(Icons.clear, size: 16, color: AppColors.secondary),
            label: Text('Clear Filters', style: TextStyle(color: AppColors.secondary)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCampsiteHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text('Camping Sites', style: AppTextStyles.titleLarge.copyWith(color: AppColors.textPrimary)),
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
            Icon(filterType.icon, size: 16, color: isSelected ? AppColors.textOnPrimary : AppColors.primary),
            const SizedBox(width: 4),
            Text(
              filterType.displayName,
              style: TextStyle(color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) => _handleFilterSelection(
          filterType: filterType,
          selected: selected,
          filter: filter,
          filterNotifier: filterNotifier,
        ),
        selectedColor: AppColors.secondary,
        backgroundColor: AppColors.surface,
        checkmarkColor: AppColors.textOnPrimary,
        showCheckmark: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
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
