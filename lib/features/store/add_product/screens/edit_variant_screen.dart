import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/features/store/add_product/models/product_variant_model.dart';
import 'package:myapp/features/store/add_product/widgets/price_input_field.dart';
import 'package:myapp/features/store/add_product/widgets/product_image_handler.dart';
import 'package:myapp/features/store/add_product/widgets/sale_price_bottom_sheet.dart';
import 'package:myapp/features/store/add_product/widgets/stock_input_field.dart';

class EditVariantScreen extends StatefulWidget {
  final ProductVariant variant;
  final bool useSameImage;
  final bool useSamePrice;
  final bool useSameStock;
  final Function(bool, List<XFile>) onSameImageToggled;
  final Function(bool, double, double?) onSamePriceToggled;
  final Function(bool, int) onSameStockToggled;

  const EditVariantScreen({
    super.key,
    required this.variant,
    required this.useSameImage,
    required this.useSamePrice,
    required this.useSameStock,
    required this.onSameImageToggled,
    required this.onSamePriceToggled,
    required this.onSameStockToggled,
  });

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

  late bool _useSameImage;
  late bool _useSamePrice;
  late bool _useSameStock;

  @override
  void initState() {
    super.initState();
    _editedVariant = widget.variant.copyWith();
    _images.addAll(_editedVariant.images.map((path) => XFile(path)));

    _useSameImage = widget.useSameImage;
    _useSamePrice = widget.useSamePrice;
    _useSameStock = widget.useSameStock;

    final priceText = _editedVariant.price == 0.0 ? '' : _editedVariant.price.toStringAsFixed(2);
    final stockText = _editedVariant.stock == 0 ? '' : _editedVariant.stock.toString();

    _priceController = TextEditingController(text: priceText);
    _salePriceController = TextEditingController(text: _editedVariant.salePrice?.toStringAsFixed(2) ?? '');
    _stockController = TextEditingController(text: stockText);

    _priceController.addListener(() {
      _updateSaveButtonState();
      if (_useSamePrice) {
        setState(() {
          _useSamePrice = false;
        });
        final price = double.tryParse(_priceController.text) ?? 0.0;
        final salePrice = double.tryParse(_salePriceController.text);
        widget.onSamePriceToggled(false, price, salePrice);
      }
    });
    _stockController.addListener(() {
      _updateSaveButtonState();
      if (_useSameStock) {
        setState(() {
          _useSameStock = false;
        });
        final stock = int.tryParse(_stockController.text) ?? 0;
        widget.onSameStockToggled(false, stock);
      }
    });
    _salePriceController.addListener((){
       _calculateDiscount();
      if (_useSamePrice) {
        setState(() {
          _useSamePrice = false;
        });
        final price = double.tryParse(_priceController.text) ?? 0.0;
        final salePrice = double.tryParse(_salePriceController.text);
        widget.onSamePriceToggled(false, price, salePrice);
      }
    });

    _calculateDiscount();
    _updateSaveButtonState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
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
        images: _images.map((image) => image.path).toList(),
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

  void _deleteVariant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Variant'),
        content: const Text('Are you sure you want to delete this variant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop('DELETE');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editedVariant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteVariant,
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
                  _updateSaveButtonState();
                  if (_useSameImage) {
                    setState(() {
                      _useSameImage = false;
                    });
                    widget.onSameImageToggled(false, _images);
                  }
                });
              },
              maxImages: 4,
              errorMessage: _imageError,
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _buildToggleSwitch(
              'Use same image for all variants',
              _useSameImage,
              (value) {
                setState(() {
                  _useSameImage = value;
                });
                widget.onSameImageToggled(value, _images);
              },
            ),
            _buildToggleSwitch(
              'Use same price for all variants',
              _useSamePrice,
              (value) {
                setState(() {
                  _useSamePrice = value;
                });
                final price = double.tryParse(_priceController.text) ?? 0.0;
                final salePrice = double.tryParse(_salePriceController.text);
                widget.onSamePriceToggled(value, price, salePrice);
              },
            ),
            _buildToggleSwitch(
              'Use same number of stock',
              _useSameStock,
              (value) {
                setState(() {
                  _useSameStock = value;
                });
                final stock = int.tryParse(_stockController.text) ?? 0;
                widget.onSameStockToggled(value, stock);
              },
            ),
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
