import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/dummy_data.dart';
import 'core/utils/hive_init.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInit.init();

  // Initialize dummy data in debug mode
  await DummyData.initialize();

  runApp(const ProviderScope(child: SecretSantaApp()));
}

class SecretSantaApp extends ConsumerWidget {
  const SecretSantaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Secret Santa Generator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
