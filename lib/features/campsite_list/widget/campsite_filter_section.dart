import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:camping_site/features/campsite_list/model/campsite_filter.dart';
import 'package:camping_site/features/campsite_list/controller/campsite_list_controller.dart';

class CampsiteFilterSection extends ConsumerWidget {
  final CampsiteFilter filter;
  final TextEditingController controller;

  const CampsiteFilterSection({super.key, required this.filter, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterNotifier = ref.read(campsiteFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          StringConstants.discoverByFilters,
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.secondaryDark),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: FilterType.values.map((type) {
              final isSelected = type.appliesTo(filter);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(type.displayName, style: TextStyle(color: AppColors.secondaryDark)),
                  selected: isSelected,
                  selectedColor: AppColors.secondaryDark.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.secondaryDark,
                  labelStyle: const TextStyle(color: AppColors.secondaryDark),
                  onSelected: (sel) => filterNotifier.toggleFilter(type, sel),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? AppColors.secondaryLight : AppColors.secondaryDark.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
              );
            }).toList(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              controller.clear();
              filterNotifier.clearAll();
            },
            icon: const Icon(Icons.clear, size: 16, color: AppColors.primaryDark),
            label: Text(StringConstants.clearFilters, style: const TextStyle(color: AppColors.primaryDark)),
          ),
        ),
      ],
    );
  }
}
