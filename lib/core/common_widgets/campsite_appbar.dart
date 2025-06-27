import 'package:camping_site/core/constants/string_constants.dart';
import 'package:camping_site/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CampSiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CampSiteAppBar({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.asset('assets/icons/camping-tent.svg', height: 32),
          const SizedBox(width: 12),
          Text(StringConstants.appTitle, style: theme.textTheme.titleMedium?.copyWith(color: AppColors.secondaryDark)),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
