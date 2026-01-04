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

  @override
  void initState() {
    super.initState();
    // Store the initial value when the widget is first created.
    _initialSalePrice = widget.salePriceController.text;
  }

  @override
  Widget build(BuildContext context) {
    // Using PopScope to handle dismissal gestures (like tapping outside the sheet).
    return PopScope(
      canPop: true, // We always allow the sheet to close.
      // Using the non-deprecated callback. The 'result' parameter is not needed here.
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // This code runs right after the pop gesture is handled.
        if (!didPop) return; // If the pop was prevented for some reason, do nothing.

        // Manually trigger validation on the form.
        final bool isFormValid = _salePriceFormKey.currentState?.validate() ?? true;

        // If the form is NOT valid when the user dismisses it,
        // revert the controller's text to its original, valid value.
        if (!isFormValid) {
          widget.salePriceController.text = _initialSalePrice;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Form(
          key: _salePriceFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClearableTextFormField(
                controller: widget.salePriceController,
                labelText: 'Sale Price',
                prefixText: '₹ ',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  // An empty value is valid, as a sale price is optional.
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  final salePrice = double.tryParse(value);
                  if (salePrice == null) {
                    return 'Please enter a valid number';
                  }
                  final originalPrice = double.tryParse(widget.priceController.text);
                  // The original price must exist and the sale price must be lower.
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
                  // The user can only press Done if the form is valid.
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
