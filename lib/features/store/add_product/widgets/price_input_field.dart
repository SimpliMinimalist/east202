
import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';

class PriceInputField extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final VoidCallback onSalePriceTapped;
  final FocusNode? priceFocusNode;

  const PriceInputField({
    super.key,
    required this.priceController,
    required this.salePriceController,
    required this.onSalePriceTapped,
    this.priceFocusNode,
  });

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
  bool get hasSalePrice =>
      widget.salePriceController.text.isNotEmpty &&
      double.tryParse(widget.salePriceController.text) != null;

  @override
  void initState() {
    super.initState();
    widget.priceController.addListener(_onPriceChanged);
    widget.salePriceController.addListener(_onPriceChanged);
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_onPriceChanged);
    widget.salePriceController.removeListener(_onPriceChanged);
    super.dispose();
  }

  void _onPriceChanged() {
    if (mounted) {
      setState(() {
        // State is managed by the controllers, just need to trigger a rebuild
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hasSalePrice) {
      return GestureDetector(
        onTap: widget.onSalePriceTapped,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Price',
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          ),
          child: Row(
            children: [
              Text(
                '₹${widget.salePriceController.text}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${widget.priceController.text}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
              ),
              const Spacer(),
              const Icon(Icons.edit, color: Colors.grey, size: 20),
            ],
          ),
        ),
      );
    } else {
      return ClearableTextFormField(
        controller: widget.priceController,
        focusNode: widget.priceFocusNode,
        labelText: 'Price',
        prefixText: '₹ ',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a price';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        suffixIcon: TextButton(
          onPressed: widget.onSalePriceTapped,
          child: const Text('Add discount'),
        ),
      );
    }
  }
}
