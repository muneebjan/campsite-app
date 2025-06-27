// app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0XFF314D55);
  static const Color primaryDark = Color(0XFF1D2E35);
  static const Color primaryLight = Color(0XFF5D7A8A);

  static const Color secondary = Color(0XFFF6745C);
  static const Color secondaryDark = Color(0XFFB14F45);
  static const Color secondaryLight = Color(0XFFF89B8A);

  static const Color background = Color(0XFFE3DEDD);
  static const Color surface = Color(0XFFFFFFFF);
  static const Color onBackground = Color(0XFF314D55);
  static const Color onSurface = Color(0XFF222222);
  static const Color error = Color(0XFFD32F2F);

  static const Color textPrimary = Color(0XFF222222);
  static const Color textSecondary = Color(0XFF757575);
  static const Color textOnPrimary = Color(0XFFFFFFFF);
  static const Color textOnSecondary = Color(0XFFFFFFFF);
}

class AppTextStyles {

  static const TextStyle featuredHeader = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
    height: 1.2,
    shadows: [Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(1, 1))],
  );

  static const TextStyle featureText = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryDark,
  );

  static const TextStyle chipText = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryDark,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(fontSize: 16, color: AppColors.textPrimary);

  static const TextStyle bodyMedium = TextStyle(fontSize: 14, color: AppColors.textSecondary);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Color Scheme
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.secondaryDark),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headlineLarge,
        displayMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles.titleLarge,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
    );
  }
}
