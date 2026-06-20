import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions/context_extensions.dart';

/// Hosts the bottom navigation bar (Translate / Dictionary / Learn /
/// History / Settings) around go_router's StatefulShellRoute branches.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        backgroundColor: context.colors.surface,
        indicatorColor: context.colors.primaryContainer,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.g_translate_outlined),
            selectedIcon: Icon(Icons.g_translate, color: context.colors.onPrimaryContainer),
            label: context.l10n.translate,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: context.colors.onPrimaryContainer),
            label: context.l10n.dictionary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: context.colors.onPrimaryContainer),
            label: context.l10n.learn,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history, color: context.colors.onPrimaryContainer),
            label: context.l10n.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: context.colors.onPrimaryContainer),
            label: context.l10n.settings,
          ),
        ],
      ),
    );
  }
}
