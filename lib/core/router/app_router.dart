import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flashcard/features/auth/presentation/pages/login_page.dart';
import 'package:flashcard/features/auth/presentation/pages/register_page.dart';
import 'package:flashcard/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:flashcard/features/task_management/presentation/pages/task_list_page.dart';
import 'package:flashcard/features/task_management/presentation/pages/task_create_page.dart';
import 'package:flashcard/features/focus_session/presentation/pages/focus_session_page.dart';
import 'package:flashcard/features/analytics/presentation/pages/analytics_page.dart';
import 'package:flashcard/features/home/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/pomodoro',
            builder: (context, state) => const PomodoroPage(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TaskListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const TaskCreatePage(),
              ),
            ],
          ),
          GoRoute(
            path: '/focus',
            builder: (context, state) => const FocusSessionPage(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsPage(),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/pomodoro')) return 1;
    if (location.startsWith('/tasks')) return 2;
    if (location.startsWith('/focus')) return 3;
    if (location.startsWith('/analytics')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/pomodoro');
      case 2:
        context.go('/tasks');
      case 3:
        context.go('/focus');
      case 4:
        context.go('/analytics');
    }
  }
}
