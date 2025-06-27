import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/core/theme/app_theme.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                colors: [AppColors.secondaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SvgPicture.asset(
                'assets/images/background.svg',
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(AppColors.secondaryLight.withValues(alpha: 0.7), BlendMode.darken),
              ),
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
}
