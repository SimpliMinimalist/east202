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
  bool _isSaveEnabled = false;
  String? _priceError;
  String? _imageError;

  @override
  void initState() {
    super.initState();
    _editedVariant = widget.variant.copyWith();
    if (_editedVariant.image != null) {
      _images.add(XFile(_editedVariant.image!));
    }

    // Initialize controllers with empty strings if values are 0
    final priceText = _editedVariant.price == 0.0 ? '' : _editedVariant.price.toStringAsFixed(2);
    final stockText = _editedVariant.stock == 0 ? '' : _editedVariant.stock.toString();

    _priceController = TextEditingController(text: priceText);
    _salePriceController = TextEditingController(text: _editedVariant.salePrice?.toStringAsFixed(2) ?? '');
    _stockController = TextEditingController(text: stockText);

    _priceController.addListener(_updateSaveButtonState);
    _stockController.addListener(_updateSaveButtonState);
    _salePriceController.addListener(_calculateDiscount);

    _calculateDiscount();
    _updateSaveButtonState();
  }

  @override
  void dispose() {
    _priceController.removeListener(_updateSaveButtonState);
    _stockController.removeListener(_updateSaveButtonState);
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _salePriceController.removeListener(_calculateDiscount);
    super.dispose();
  }

  void _updateSaveButtonState() {
    setState(() {
      _isSaveEnabled = _images.isNotEmpty && _priceController.text.isNotEmpty;
      if (_images.isNotEmpty) {
        _imageError = null;
      }
      if (_priceController.text.isNotEmpty) {
        _priceError = null;
      }
    });
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
    setState(() {
      _imageError = _images.isEmpty ? 'Please select at least one image.' : null;
      _priceError = _priceController.text.isEmpty ? 'Please enter a price.' : null;
    });

    if (_imageError == null && _priceError == null) {
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
                  _updateSaveButtonState();
                });
              },
              maxImages: 4,
              errorMessage: _imageError,
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
              errorMessage: _priceError,
            ),
            const SizedBox(height: 16),
            StockInputField(
              controller: _stockController,
              labelText: 'In stock',
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: const Offset(0, -7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _isSaveEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    foregroundColor: _isSaveEnabled
                        ? Theme.of(context).colorScheme.onPrimary
                        : Colors.grey.shade600,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
