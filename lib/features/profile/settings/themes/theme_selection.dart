// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/core/theme.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('System Default'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            ),
            ListTile(
              title: const Text('Light'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            ),
            ListTile(
              title: const Text('Dark'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}
