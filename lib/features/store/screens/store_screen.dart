import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/features/add_product/models/product_model.dart';
import 'package:myapp/features/add_product/screens/add_product_screen.dart';
import 'package:myapp/features/store/widgets/add_category_bottom_sheet.dart';
import 'package:myapp/providers/category_provider.dart';
import 'package:myapp/providers/selection_provider.dart';
import 'package:myapp/shared/widgets/custom_search_bar.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../add_product/widgets/product_card.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final selectionProvider = Provider.of<SelectionProvider>(context);

    final List<Product> filteredProducts;
    if (categoryProvider.selectedCategory == 'All') {
      filteredProducts = productProvider.products;
    } else {
      filteredProducts = productProvider.products
          .where((p) => p.categories.contains(categoryProvider.selectedCategory))
          .toList();
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CustomSearchBar(
                  hintText: 'Search Products',
                  onTap: () => context.push('/search'),
                  hasBackButton: false,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildCategoryFilters(),
              ),
            ),
            filteredProducts.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                      child: Text('No products yet. Add one!'),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          final isSelected =
                              selectionProvider.selectedProducts.contains(product.id);
                          return GestureDetector(
                            onTap: () {
                              if (selectionProvider.isSelectionMode) {
                                selectionProvider.toggleSelection(product.id);
                              } else {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddProductScreen(product: product),
                                  ),
                                );
                              }
                            },
                            onLongPress: () {
                              selectionProvider.toggleSelection(product.id);
                            },
                            child: ProductCard(
                              product: product,
                              isSelected: isSelected,
                            ),
                          );
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final productProvider = Provider.of<ProductProvider>(context);
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final allCategories = ['All', ...categoryProvider.categories];

        final selectedStyle = TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        );

        final unselectedStyle = TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w300,
        );

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: allCategories.length + 1, // +1 for the add button
            itemBuilder: (context, index) {
              if (index == allCategories.length) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ChoiceChip(
                    visualDensity: const VisualDensity(vertical: -2),
                    label: const Icon(Icons.add, size: 24),
                    selected: false,
                    showCheckmark: false,
                    onSelected: (_) => showAddCategoryBottomSheet(context),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                );
              }

              final category = allCategories[index];
              final isSelected = category == categoryProvider.selectedCategory;
              final productCount = category == 'All'
                  ? productProvider.products.length
                  : productProvider.products
                      .where((p) => p.categories.contains(category))
                      .length;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  visualDensity: const VisualDensity(vertical: -2),
                  label: Text('$category $productCount'),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (selected) {
                    if (selected) {
                      categoryProvider.selectCategory(category);
                    }
                  },
                  backgroundColor: isSelected
                      ? Theme.of(context).primaryColor.withAlpha(25)
                      : Colors.grey[200],
                  selectedColor: Theme.of(context).primaryColor.withAlpha(51),
                  labelStyle: isSelected ? selectedStyle : unselectedStyle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
