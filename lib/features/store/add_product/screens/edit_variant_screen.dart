import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/store/add_product/models/product_variant_model.dart';
import 'package:myapp/features/store/add_product/widgets/price_input_field.dart';
import 'package:myapp/features/store/add_product/widgets/product_image_handler.dart';
import 'package:myapp/features/store/add_product/widgets/sale_price_bottom_sheet.dart';
import 'package:myapp/features/store/add_product/widgets/stock_input_field.dart';

class EditVariantScreen extends StatefulWidget {
  final ProductVariant variant;

  const EditVariantScreen({super.key, required this.variant});

  @override
  State<EditVariantScreen> createState() => _EditVariantScreenState();
}

class _EditVariantScreenState extends State<EditVariantScreen> {
  late final TextEditingController _priceController;
  late final TextEditingController _salePriceController;
  late final TextEditingController _stockController;
  late ProductVariant _editedVariant;
  final List<XFile> _images = [];
  String _discountPercentage = '';

  @override
  void initState() {
    super.initState();
    _editedVariant = widget.variant.copyWith();
    if (_editedVariant.image != null) {
      _images.add(XFile(_editedVariant.image!));
    }
    _priceController = TextEditingController(text: _editedVariant.price.toStringAsFixed(2));
    _salePriceController = TextEditingController(text: _editedVariant.salePrice?.toStringAsFixed(2) ?? '');
    _stockController = TextEditingController(text: _editedVariant.stock.toString());
    _salePriceController.addListener(_calculateDiscount);
    _calculateDiscount();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _salePriceController.removeListener(_calculateDiscount);
    super.dispose();
  }

  void _calculateDiscount() {
    final originalPrice = double.tryParse(_priceController.text);
    final salePrice = double.tryParse(_salePriceController.text);

    if (originalPrice != null &&
        salePrice != null &&
        originalPrice > 0 &&
        salePrice < originalPrice) {
      final discount = ((originalPrice - salePrice) / originalPrice) * 100;
      if (mounted) {
        setState(() {
          _discountPercentage = '(${discount.toStringAsFixed(0)}% off)';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _discountPercentage = '';
        });
      }
    }
  }

  void _saveChanges() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final salePrice = double.tryParse(_salePriceController.text);
    final stock = int.tryParse(_stockController.text) ?? 0;
    _editedVariant = _editedVariant.copyWith(
      price: price,
      salePrice: salePrice,
      stock: stock,
      image: _images.isNotEmpty ? _images.first.path : null,
    );
    Navigator.of(context).pop(_editedVariant);
  }

  void _showSalePriceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SalePriceBottomSheet(
          priceController: _priceController,
          salePriceController: _salePriceController,
        );
      },
    ).whenComplete(() {
      _calculateDiscount();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedVariant.name),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageHandler(
              initialImages: _images,
              onImagesChanged: (newImages) {
                setState(() {
                  _images.clear();
                  _images.addAll(newImages);
                });
              },
              maxImages: 4,
            ),
            const SizedBox(height: 24),
            // Attributes
            ..._editedVariant.attributes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: Theme.of(context).textTheme.titleMedium),
                    Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            PriceInputField(
              priceController: _priceController,
              salePriceController: _salePriceController,
              onSalePriceTapped: _showSalePriceBottomSheet,
              discountPercentage: _discountPercentage,
            ),
            const SizedBox(height: 16),
            StockInputField(
              controller: _stockController,
              labelText: 'In stock',
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // Shipping
            Row(
              children: [
                const Icon(Icons.local_shipping_outlined),
                const SizedBox(width: 8),
                Text('Shipping', style: Theme.of(context).textTheme.titleMedium),
              ],
            )
          ],
        ),
      ),
    );
  }
}
