import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';

part 'settings_screen.g.dart';

/// Provider for theme mode using Riverpod code generation
@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('theme_mode') ?? 'system';
    state = ThemeMode.values.firstWhere(
      (mode) => mode.toString() == 'ThemeMode.$themeModeString',
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.toString().split('.').last);
  }
}

/// Screen for app settings
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.palette),
            title: Text('Appearance'),
            subtitle: Text('Customize app theme'),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Reveal History'),
            subtitle: const Text('View all past reveals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppConstants.revealHistoryRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Tutorials'),
            subtitle: const Text('Learn how to use the app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push(AppConstants.helpRoute);
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('Secret Santa Generator v1.0.0'),
          ),
        ],
      ),
    );
  }
}
