import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/features/store/providers/store_provider.dart';
import 'package:myapp/features/profile/settings/screen_settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (storeProvider.logo != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(storeProvider.logo!),
              ),
            const SizedBox(height: 20),
            Text(
              storeProvider.storeName.isNotEmpty
                  ? storeProvider.storeName
                  : 'My Store',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
