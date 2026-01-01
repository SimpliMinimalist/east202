import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
import 'package:myapp/features/orders/screens/orders_screen.dart';
import 'package:myapp/features/profile/screens/profile_screen.dart';
import 'package:myapp/features/store/screens/store_screen.dart';
import 'package:myapp/providers/selection_provider.dart';
import 'package:myapp/shared/widgets/floating_action_button.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    final selectionProvider =
        Provider.of<SelectionProvider>(context, listen: false);
    if (selectionProvider.isSelectionMode) {
      selectionProvider.clearSelection();
    }
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = Theme.of(context).colorScheme.primary;
    final Color unselectedColor =
        Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          StoreScreen(),
          OrdersScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: Duration.zero,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return child;
        },
        child: _selectedIndex == 0 || _selectedIndex == 1
            ? AddProductFab(
                key: const ValueKey('fab'),
                onPressed: _selectedIndex == 0
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProductScreen(),
                            fullscreenDialog: true,
                          ),
                        );
                      }
                    : null,
              )
            : const SizedBox(key: ValueKey('empty')), // Use SizedBox and key
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onDestinationSelected: (index) => _onItemTapped(index),
            selectedIndex: _selectedIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: SvgPicture.asset(
                  'assets/icons/store_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/store.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(unselectedColor, BlendMode.srcIn),
                ),
                label: 'Store',
              ),
              NavigationDestination(
                selectedIcon: SvgPicture.asset(
                  'assets/icons/orders_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/orders.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(unselectedColor, BlendMode.srcIn),
                ),
                label: 'Orders',
              ),
              NavigationDestination(
                selectedIcon: SvgPicture.asset(
                  'assets/icons/profile_selected.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(selectedColor, BlendMode.srcIn),
                ),
                icon: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  width: 24,
                  height: 24,
                  colorFilter:
                      ColorFilter.mode(unselectedColor, BlendMode.srcIn),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    final selectionProvider = Provider.of<SelectionProvider>(context);

    if (selectionProvider.isSelectionMode) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => selectionProvider.clearSelection(),
        ),
        title: Text('${selectionProvider.selectedProducts.length} selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => selectionProvider.deleteSelectedProducts(context),
          ),
        ],
      );
    }

    return null;
  }
}
