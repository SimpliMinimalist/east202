import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/custom_search_bar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CustomSearchBar(
                  hintText: 'Search Orders',
                  onTap: () => context.push('/search_orders'),
                  hasBackButton: false,
                ),
              ),
            ),
            const SliverFillRemaining(
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
