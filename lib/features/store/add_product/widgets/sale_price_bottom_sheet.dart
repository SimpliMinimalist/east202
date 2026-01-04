
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                if (value != null && value.isNotEmpty) {
                  final salePrice = double.tryParse(value);
                  final originalPrice =
                      double.tryParse(widget.priceController.text);
                  if (salePrice != null &&
                      originalPrice != null &&
                      salePrice >= originalPrice) {
                    return 'Sale price must be less than the original price.';
                  }
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_salePriceFormKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Done'),
            )
          ],
        ),
      ),
    );
  }
}
