import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/view/campsite_list_screen.dart';

import 'core/theme/app_theme.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _tabs = [
    CampsiteListScreen(),
    Center(child: Text('Map Page Placeholder', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      body: _tabs[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) => ref.read(selectedTabProvider.notifier).state = index,
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.secondaryDark,
            unselectedItemColor: AppColors.textSecondary,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              height: 1.5,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIndex == 0
                        ? AppColors.secondaryDark.withValues(alpha: 0.15)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.home,
                    size: 24,
                    color: selectedIndex == 0
                        ? AppColors.secondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIndex == 1
                        ? AppColors.secondaryDark.withValues(alpha: 0.15)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.map,
                    size: 24,
                    color: selectedIndex == 1
                        ? AppColors.secondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                label: 'Map',
              ),
            ],
          ),
        ),
      ),
    );
  }
}