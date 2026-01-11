import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';

class SalePriceBottomSheet extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController salePriceController;

  const SalePriceBottomSheet({
    super.key,
    required this.priceController,
    required this.salePriceController,
  });

  @override
  State<SalePriceBottomSheet> createState() => _SalePriceBottomSheetState();
}

class _SalePriceBottomSheetState extends State<SalePriceBottomSheet> {
  final _salePriceFormKey = GlobalKey<FormState>();
  late String _initialSalePrice;
  String _discountPercentage = '';

  @override
  void initState() {
    super.initState();
    _initialSalePrice = widget.salePriceController.text;
    widget.salePriceController.addListener(_calculateDiscount);
    _calculateDiscount(); // Initial calculation
  }

  @override
  void dispose() {
    widget.salePriceController.removeListener(_calculateDiscount);
    super.dispose();
  }

  void _calculateDiscount() {
    final originalPrice = double.tryParse(widget.priceController.text);
    final salePrice = double.tryParse(widget.salePriceController.text);

    if (originalPrice != null &&
        salePrice != null &&
        originalPrice > 0 &&
        salePrice < originalPrice) {
      final discount = ((originalPrice - salePrice) / originalPrice) * 100;
      // Update the state with the formatted discount string
      if (mounted) {
        setState(() {
          _discountPercentage = '(${discount.toStringAsFixed(0)}% off)';
        });
      }
    } else {
      // Clear the discount string if not applicable
      if (mounted) {
        setState(() {
          _discountPercentage = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) return;
        // On dismissal, if the form is invalid, revert to the initial price.
        if (!(_salePriceFormKey.currentState?.validate() ?? true)) {
          widget.salePriceController.text = _initialSalePrice;
        }
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          MediaQuery.of(context).viewInsets.bottom + 40.0, // Adjust for keyboard
        ),
        child: Form(
          key: _salePriceFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The ClearableTextFormField now includes the suffixText property
              ClearableTextFormField(
                controller: widget.salePriceController,
                labelText: 'Sale Price',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // Pass the discount percentage to be shown inside the field
                suffixText: _discountPercentage,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  final salePrice = double.tryParse(value);
                  if (salePrice == null) {
                    return 'Please enter a valid number';
                  }
                  final originalPrice = double.tryParse(widget.priceController.text);
                  if (originalPrice != null && salePrice >= originalPrice) {
                    return 'Sale price must be less than the original price.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_salePriceFormKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
