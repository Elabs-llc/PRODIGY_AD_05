import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../../core/constants/app_constants.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            subtitle: Text(_getThemeModeLabel(themeMode)),
            onTap: () => _showThemeDialog(context, ref),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: Text(AppConstants.appVersion),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Source Code'),
            subtitle: const Text('View on GitHub'),
            onTap: () async {
              final uri = Uri.parse('https://github.com/Elabs-llc/PRODIGY_AD_05');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('License'),
            subtitle: const Text('MIT License'),
            onTap: () => _showLicenseDialog(context),
          ),

          const Divider(),

          // Data Section
          _SectionHeader(title: 'Data & Privacy'),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy'),
            subtitle: const Text('All data is stored locally on your device'),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Storage'),
            subtitle: const Text('Manage stored QR codes'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Use History page to manage QR codes'),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '© 2024 QR Code Pro\nBuilt with Flutter',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: ref.read(themeModeProvider),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: ref.read(themeModeProvider),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System default'),
              value: ThemeMode.system,
              groupValue: ref.read(themeModeProvider),
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('License'),
        content: const SingleChildScrollView(
          child: Text(
            'MIT License\n\n'
            'Copyright (c) 2024 QR Code Pro\n\n'
            'Permission is hereby granted, free of charge, to any person obtaining a copy '
            'of this software and associated documentation files (the "Software"), to deal '
            'in the Software without restriction, including without limitation the rights '
            'to use, copy, modify, merge, publish, distribute, sublicense, and/or sell '
            'copies of the Software, and to permit persons to whom the Software is '
            'furnished to do so, subject to the following conditions:\n\n'
            'The above copyright notice and this permission notice shall be included in all '
            'copies or substantial portions of the Software.\n\n'
            'THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR '
            'IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, '
            'FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE '
            'AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER '
            'LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, '
            'OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE '
            'SOFTWARE.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
