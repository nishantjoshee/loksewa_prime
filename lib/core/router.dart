import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/feed/feed_screen.dart';
import '../features/search/search_screen.dart';
import '../features/bookmarks/bookmarks_screen.dart';
import '../features/detail/detail_screen.dart';
import '../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/feed',
    routes: [
      GoRoute(
        path: '/feed',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: FeedScreen()),
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SearchScreen()),
      ),
      GoRoute(
        path: '/bookmarks',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BookmarksScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SettingsScreen()),
      ),
      GoRoute(
        path: '/detail/:entryId',
        pageBuilder: (context, state) => MaterialPage(
          child: DetailScreen(entryId: state.pathParameters['entryId']!),
        ),
      ),
    ],
  );
});
