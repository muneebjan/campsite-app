import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/features/campsite_list/controller/campsite_list_controller.dart';
import 'package:camping_site/core/theme/app_theme.dart';

class CampsiteSearchField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const CampsiteSearchField({super.key, required this.controller});

  @override
  ConsumerState<CampsiteSearchField> createState() => _CampsiteSearchFieldState();
}

class _CampsiteSearchFieldState extends ConsumerState<CampsiteSearchField> {
  @override
  Widget build(BuildContext context) {
    final filterNotifier = ref.read(campsiteFilterProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: AppColors.secondaryDark),
        decoration: InputDecoration(
          labelText: StringConstants.searchCampsites,
          labelStyle: TextStyle(color: AppColors.secondaryDark.withValues(alpha: 0.8), fontSize: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          prefixIcon: const Icon(Icons.search, color: AppColors.secondaryDark, size: 20),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            borderSide: const BorderSide(color: AppColors.secondaryDark, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.transparent,
          isDense: true,
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.secondaryDark, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    widget.controller.clear();
                    filterNotifier.updateSearch('');
                    setState(() {}); // Rebuild to hide suffixIcon
                  },
                )
              : null,
        ),
        onChanged: (value) {
          filterNotifier.updateSearch(value);
          setState(() {}); // Rebuild to show/hide suffixIcon
        },
      ),
    );
  }
}
