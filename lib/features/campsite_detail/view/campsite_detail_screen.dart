import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/features/campsite_list/provider/campsite_list_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/core/constants/string_constants.dart';

class CampsiteDetailScreen extends ConsumerWidget {
  final String campsiteId;
  static const double _imageHeight = 280;
  static const double _sectionSpacing = 24;
  static const double _itemSpacing = 16;
  static const double _iconSize = 20;
  static const double _containerRadius = 12;

  const CampsiteDetailScreen({super.key, required this.campsiteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCampsites = ref.watch(campsiteListProvider);
    final theme = Theme.of(context);

    return asyncCampsites.when(
      data: (campsites) {
        try {
          final campsite = campsites.firstWhere((c) => c.id == campsiteId);
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context, campsite),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(campsite),
                        SizedBox(height: _sectionSpacing),
                        _buildDescriptionSection(),
                        SizedBox(height: _sectionSpacing),
                        _buildPriceSection(campsite, theme),
                        SizedBox(height: _sectionSpacing),
                        _buildFeaturesSection(campsite),
                        SizedBox(height: _sectionSpacing),
                        _buildLocationSection(campsite),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } catch (e) {
          return _buildErrorScreen(StringConstants.campsiteNotFound);
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _buildErrorScreen('Error: $err'),
    );
  }

  // appbar
  SliverAppBar _buildAppBar(BuildContext context, Campsite campsite) {
    return SliverAppBar(
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          campsite.label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryDark,
            // shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(1, 1))],
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.secondaryDark),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // Main image section
  Widget _buildImageSection(Campsite campsite) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_containerRadius),
      child: CachedNetworkImage(
        imageUrl: campsite.photo,
        height: _imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          color: AppColors.background,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, __, ___) =>
            Container(color: AppColors.background, child: const Icon(Icons.broken_image, size: 48)),
      ),
    );
  }

  // Generated description section
  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.aboutCampsite,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
        ),
        SizedBox(height: _itemSpacing / 2),
        Text(StringConstants.description, style: const TextStyle(fontSize: 15, height: 1.5)),
      ],
    );
  }

  // Price section with icon in rounded container
  Widget _buildPriceSection(Campsite campsite, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(_containerRadius)),
      child: Row(
        children: [
          Icon(Icons.euro, size: _iconSize, color: AppColors.secondaryDark),
          SizedBox(width: _itemSpacing / 2),
          Text(StringConstants.pricePerNight, style: theme.textTheme.titleMedium),
          Text(
            '€${campsite.pricePerNight.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
          ),
        ],
      ),
    );
  }

  // Features section with icons in rounded container
  Widget _buildFeaturesSection(Campsite campsite) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(_containerRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            StringConstants.features,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
          ),
          SizedBox(height: _itemSpacing / 2),
          _buildFeatureItem(Icons.water_drop, StringConstants.closeToWater, campsite.closeToWater),
          _buildFeatureItem(Icons.fireplace, StringConstants.campfireAllowed, campsite.campFireAllowed),
          _buildFeatureItem(
            Icons.language,
            '${StringConstants.hostLanguages} ${campsite.hostLanguages.join(', ')}',
            true,
          ),
        ],
      ),
    );
  }

  // Location section with map preview
  Widget _buildLocationSection(Campsite campsite) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringConstants.location,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
        ),
        SizedBox(height: _itemSpacing / 2),
        Row(
          children: [
            Icon(Icons.location_on, size: _iconSize, color: AppColors.secondaryDark),
            SizedBox(width: _itemSpacing / 2),
            Text('Lat: ${campsite.geoLocation.lat.toStringAsFixed(4)}', style: const TextStyle(fontSize: 14)),
            SizedBox(width: _itemSpacing),
            Text('Lng: ${campsite.geoLocation.lng.toStringAsFixed(4)}', style: const TextStyle(fontSize: 14)),
          ],
        ),
        SizedBox(height: _itemSpacing),
        Container(
          height: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(_containerRadius), color: AppColors.background),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: AppColors.secondaryDark),
                SizedBox(height: 8),
                Text(StringConstants.mapView, style: TextStyle(color: AppColors.secondaryDark)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Reusable feature item widget
  Widget _buildFeatureItem(IconData icon, String text, bool isAvailable) {
    return Padding(
      padding: EdgeInsets.only(bottom: _itemSpacing / 2),
      child: Row(
        children: [
          Icon(icon, size: _iconSize, color: isAvailable ? AppColors.secondaryDark : Colors.grey),
          SizedBox(width: _itemSpacing / 2),
          Text(text, style: TextStyle(color: isAvailable ? Colors.black87 : Colors.grey)),
        ],
      ),
    );
  }

  // Error screen widget
  Scaffold _buildErrorScreen(String message) {
    return Scaffold(
      appBar: AppBar(title: const Text(StringConstants.errorTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(message, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
