import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_notifier.dart';
import '../screens/app_shell.dart';
import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier,
  redirect: (BuildContext context, GoRouterState state) {
    final bool estaLogueado = authNotifier.estaLogueado;
    final bool enLogin = state.uri.path == '/login';
    if (!estaLogueado && !enLogin) return '/login';


    if (estaLogueado && enLogin) return '/';

    return null;
  },

  routes: [
  
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          builder: (context, state) {

            final String search = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(search: search);
          },
          routes: [
      
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final int id =
                    int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                return DetailScreen(postId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(child: Text('Página no encontrada: ${state.uri}')),
  ),
);
