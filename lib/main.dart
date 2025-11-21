import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/logging/app_logger.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage_service.dart';
import 'presentation/pages/home/home_page.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  try {
    final localStorage = LocalStorageService();
    await localStorage.init();
    AppLogger.info('App initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize app', e, stackTrace);
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'QR Code Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomePage(),
    );
  }
}
