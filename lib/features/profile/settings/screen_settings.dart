import 'package:flutter/material.dart';
import 'package:myapp/features/profile/settings/themes/theme_selection.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Themes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ThemesScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(child: Text('Other settings will appear here')),
            ),
          ],
        ),
      ),
    );
  }
}
