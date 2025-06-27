import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Camping Site',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(),
      routerConfig: router,
      builder: (context, child) {
        // Global error handling
        ErrorWidget.builder = (errorDetails) => Scaffold(
          body: Center(child: Text('App Error: ${errorDetails.exception}')),
        );
        return child!;
      },
    );
  }
}