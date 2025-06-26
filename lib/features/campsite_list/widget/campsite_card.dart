import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:go_router/go_router.dart';
import 'package:camping_site/core/theme/app_theme.dart';

class CampsiteCard extends StatelessWidget {
  final Campsite campsite;
  static const double _imageSize = 100;
  static const double _iconSize = 16;
  static const double _borderRadius = 12;
  static const double _padding = 12;

  const CampsiteCard({super.key, required this.campsite});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: AppColors.secondaryDark.withValues(alpha: 25),
      shape: _cardShape,
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onTap: () => context.push('/detail/${campsite.id}'),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              _buildCampsiteImage(),
              const SizedBox(width: _padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildTitleAndPrice(context), const SizedBox(height: 8), _buildFeatureChips()],
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

  // Placeholder widget
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryDark,
          ),
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
          Text(campsite.pricePerNight.toStringAsFixed(2), style: _chipTextStyle),
        ],
      ),
    );
  }

  // Feature chips row
  Widget _buildFeatureChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (campsite.closeToWater) _buildFeatureChip(Icons.water_drop, 'Water'),
        if (campsite.campFireAllowed) _buildFeatureChip(Icons.fireplace, 'Campfire'),
      ],
    );
  }

  // Individual feature chip
  Widget _buildFeatureChip(IconData icon, String label) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: AppColors.secondaryDark.withValues(alpha: 25),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _iconSize, color: AppColors.secondaryDark),
          const SizedBox(width: 4),
          Text(label, style: _chipTextStyle),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.secondaryDark.withValues(alpha: 50), width: 1),
      ),
    );
  }

  // Consistent text style for chips
  TextStyle get _chipTextStyle => TextStyle(fontSize: 12, color: AppColors.secondaryDark);
}
