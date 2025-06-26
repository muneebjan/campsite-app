import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camping_site/features/campsite_detail/view/campsite_detail_screen.dart';
import 'package:camping_site/features/welcome/welcome_screen.dart';
import 'package:camping_site/features/welcome/main_screen.dart';

enum AppRoute {
  welcome('/welcome'),
  home('/'),
  detail('detail/:id');

  final String path;
  const AppRoute(this.path);
}

//  Route configuration with error handling
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.welcome.path,
    debugLogDiagnostics: true,
    routes: [
      // Welcome Screen
      GoRoute(
        path: AppRoute.welcome.path,
        name: AppRoute.welcome.name,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const WelcomeScreen()),
      ),

      // Home Screen (MainScreen with tabs)
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const MainScreen()),

        routes: [
          // Detail Screen as sub-route of home
          GoRoute(
            path: AppRoute.detail.path.split('/').last, // 'detail/:id'
            name: AppRoute.detail.name,
            pageBuilder: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null) {
                return _errorPage(state, 'Missing campsite ID');
              }
              return MaterialPage(
                key: state.pageKey,
                child: CampsiteDetailScreen(campsiteId: id),
              );
            },
          ),
        ],
      ),
    ],

    // Error handling
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
    ),
  );
});

// For error pages
Page _errorPage(GoRouterState state, String message) {
  return MaterialPage(
    key: state.pageKey,
    child: Scaffold(body: Center(child: Text(message))),
  );
}
