import 'package:flutter/material.dart';
import 'package:camping_site/features/campsite_list/model/campsite.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/core/constants/string_constants.dart';
class CampsiteDetailFeatureSectionWidget extends StatelessWidget {
  const CampsiteDetailFeatureSectionWidget({
    super.key,
    required double containerRadius,
    required double itemSpacing,
    required double iconSize,
    required this.campsite,
  }) : _containerRadius = containerRadius,
        _itemSpacing = itemSpacing,
        _iconSize = iconSize;

  final double _containerRadius;
  final double _itemSpacing;
  final double _iconSize;
  final Campsite campsite;

  @override
  Widget build(BuildContext context) {
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

}
