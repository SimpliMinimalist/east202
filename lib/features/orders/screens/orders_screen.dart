import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/custom_search_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
              child: CustomSearchBar(
                hintText: 'Search Orders',
                onTap: () => context.push('/search_orders'),
                hasBackButton: false,
                readOnly: true,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Orders will be displayed here.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
