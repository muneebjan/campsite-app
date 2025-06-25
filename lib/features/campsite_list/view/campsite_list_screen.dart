import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_card.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';

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
    final filter = ref.watch(campsiteFilterProvider);
    final filterNotifier = ref.read(campsiteFilterProvider.notifier);
    final campsiteAsync = ref.watch(campsiteListProvider);
    final filteredCampsites = ref.watch(filteredCampsiteListProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Campsites')),
      body: campsiteAsync.when(
        data: (_) => _buildContent(
          context: context,
          filter: filter,
          filterNotifier: filterNotifier,
          filteredCampsites: filteredCampsites,
          theme: theme,
          textTheme: textTheme,
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load campsites: ${err.toString()}',
              style: textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required CampsiteFilter filter,
    required StateController<CampsiteFilter> filterNotifier,
    required List<Campsite> filteredCampsites,
    required ThemeData theme,
    required TextTheme textTheme,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: _buildSearchField(filter, filterNotifier)),
          SliverToBoxAdapter(child: _buildFeaturedSection(theme)),
          SliverToBoxAdapter(child: _buildFilterSection(filter, filterNotifier, theme)),
          SliverToBoxAdapter(child: _buildCampsiteHeader(textTheme)),
          if (filteredCampsites.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No campsites found',
                  style: textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
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
    );
  }

  Widget _buildSearchField(CampsiteFilter filter, StateController<CampsiteFilter> filterNotifier) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search by name',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
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

  Widget _buildFeaturedSection(ThemeData theme) {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Center(
        child: Text(
          'Featured Camping Location',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(CampsiteFilter filter, StateController<CampsiteFilter> filterNotifier, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Discover by filters', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
            icon: Icon(Icons.clear, size: 16, color: theme.colorScheme.error),
            label: Text('Clear Filters', style: TextStyle(color: theme.colorScheme.error)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCampsiteHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text('Camping Sites', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
          children: [Icon(filterType.icon, size: 16), const SizedBox(width: 4), Text(filterType.displayName)],
        ),
        selected: isSelected,
        onSelected: (selected) => _handleFilterSelection(
          filterType: filterType,
          selected: selected,
          filter: filter,
          filterNotifier: filterNotifier,
        ),
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
        showCheckmark: true,
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
