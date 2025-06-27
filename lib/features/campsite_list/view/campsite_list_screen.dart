import 'package:camping_site/core/common_widgets/campsite_appbar.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_list_widgets/campsite_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:camping_site/features/campsite_list/controller/campsite_list_controller.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_list_widgets/featured_section.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_list_widgets/campsite_filter_section.dart';
import 'package:camping_site/features/campsite_list/widget/campsite_list_widgets/campsite_card.dart';
import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/core/theme/app_theme.dart';

class CampsiteListScreen extends ConsumerStatefulWidget {
  const CampsiteListScreen({super.key});
  @override
  ConsumerState<CampsiteListScreen> createState() => _CampsiteListScreenState();
}

class _CampsiteListScreenState extends ConsumerState<CampsiteListScreen> {
  final _searchCtrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filter = ref.watch(campsiteFilterProvider);
    final filtered = ref.watch(filteredCampsiteListProvider);
    final async = ref.watch(campsiteListProvider);

    return Scaffold(
      appBar: CampSiteAppBar(theme: theme),
      body: async.when(
        data: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(child: CampsiteSearchField(controller: _searchCtrl)),
              const SliverToBoxAdapter(child: FeaturedSection()),
              SliverToBoxAdapter(
                child: CampsiteFilterSection(filter: filter, controller: _searchCtrl),
              ),
              SliverToBoxAdapter(child: _buildHeader(theme)),
              if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(child: Text(StringConstants.noCampsitesFound, style: theme.textTheme.bodyLarge)),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, idx) => CampsiteCard(campsite: filtered[idx]),
                    childCount: filtered.length,
                  ),
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => Center(
          child: Text(StringConstants.errorLoading, style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.error)),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        StringConstants.campingSites,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.secondaryDark),
      ),
    );
  }
}
