import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:go_router/go_router.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/routing/app_router.dart';

class CampsiteCard extends StatelessWidget {
  final Campsite campsite;
  static const double _imageSize = 90;
  static const double _iconSize = 16;
  static const double _borderRadius = 12;
  static const double _padding = 12;

  const CampsiteCard({super.key, required this.campsite});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 0,
      color: AppColors.secondaryDark.withValues(alpha: 25),
      shape: _cardShape,
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: () => context.goNamed(AppRoute.detail.name, pathParameters: {'id': campsite.id}),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              _buildCampsiteImage(),
              const SizedBox(width: _padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildTitleAndPrice(context), const SizedBox(height: 8), _buildFeatureIcons()],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: _iconSize),
            ],
          ),
        ),
      ),
    );
  }

  // Shape for the card
  RoundedRectangleBorder get _cardShape => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(_borderRadius),
    side: BorderSide(color: AppColors.secondaryDark.withValues(alpha: 50), width: 1),
  );

  // Image widget
  Widget _buildCampsiteImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: campsite.photo,
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
        placeholder: _buildImagePlaceholder,
        errorWidget: _buildImageError,
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, String url) {
    return Container(
      color: AppColors.background,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // Error widget
  Widget _buildImageError(BuildContext context, String url, dynamic error) {
    return Container(color: AppColors.background, child: const Icon(Icons.broken_image));
  }

  // Title and price row
  Widget _buildTitleAndPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          campsite.label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.secondaryDark),
        ),
        _buildPriceChip(),
      ],
    );
  }

  // Price chip widget
  Widget _buildPriceChip() {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: AppColors.secondaryDark.withValues(alpha: 25),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.euro, size: _iconSize, color: AppColors.secondaryDark),
          const SizedBox(width: 4),
          Text(campsite.pricePerNight.toStringAsFixed(2), style: AppTextStyles.chipText),
        ],
      ),
    );
  }

  Widget _buildFeatureIcons() {
    return Row(
      children: [
        if (campsite.closeToWater)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                Icon(Icons.water_drop, size: _iconSize, color: AppColors.secondaryDark),
                const SizedBox(width: 4),
                Text('Water', style: AppTextStyles.featureText),
              ],
            ),
          ),
        if (campsite.campFireAllowed)
          Row(
            children: [
              Icon(Icons.fireplace, size: _iconSize, color: AppColors.secondaryDark),
              const SizedBox(width: 4),
              Text('Campfire', style: AppTextStyles.featureText),
            ],
          ),
      ],
    );
  }
}
