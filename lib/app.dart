import 'package:camping_site/initial_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:camping_site/features/campsite_list/view/campsite_list_screen.dart';
import 'package:camping_site/features/campsite_detail/view/campsite_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => const InitialScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) => const CampsiteListScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return CampsiteDetailScreen(campsiteId: id);
          },
        ),
      ],
    ),
  ],
  initialLocation: '/welcome',
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Camping Site',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: _router,
    );
  }
}
