import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routing_flow/app/auth/sign_up_screen.dart';
import 'package:routing_flow/app/main/details_screen.dart';
import 'package:routing_flow/app/main/notification_screen.dart';
import 'package:routing_flow/app/main/search_screen.dart';
import 'auth/login_screen.dart';
import 'main/app_startup.dart';
import 'main/home_screen.dart';
import 'main/main_screen.dart';
import 'main/profile_screen.dart';
import 'services/auth_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Define routes
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authServiceProvider);

  return GoRouter(
    navigatorKey: navigatorKey,
    redirect: (context, state) {
      // Redirect logic based on auth state
      final isLoggedIn = authState; // Use the boolean value directly
      if (!isLoggedIn && !state.uri.toString().startsWith('/auth')) {
        return '/auth/login';
      }
      if (isLoggedIn && state.uri.toString().startsWith('/auth')) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) {
          return AppStartupWidget(onLoaded: (_) => const SizedBox.shrink());
        },
      ),
      // Auth Flow
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Main App Flow (Protected)
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
          // Nested routes for each tab
          GoRoute(
            path: '/details/:id',
            builder: (context, state) => DetailsScreen(
              id: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
});
