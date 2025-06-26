import 'package:camping_site/features/map_feature/view/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_list/view/campsite_list_screen.dart';
import 'package:camping_site/core/theme/app_theme.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class _TabItem {
  final IconData icon;
  final String label;

  const _TabItem({required this.icon, required this.label});
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _tabs = [CampsiteListScreen(), CampsiteMapScreen()];

  static const List<_TabItem> _tabItems = [
    _TabItem(icon: Icons.home, label: 'Home'),
    _TabItem(icon: Icons.map, label: 'Map'),
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
            BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2)),
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
            selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.5),
            unselectedLabelStyle: const TextStyle(fontSize: 12, height: 1.5),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            items: List.generate(_tabItems.length, (index) {
              final tab = _tabItems[index];
              final isSelected = selectedIndex == index;

              return BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.secondaryDark.withValues(alpha: 0.15) : Colors.transparent,
                  ),
                  child: Icon(
                    tab.icon,
                    size: 24,
                    color: isSelected ? AppColors.secondaryDark : AppColors.textSecondary,
                  ),
                ),
                label: tab.label,
              );
            }),
          ),
        ),
      ),
    );
  }
}
