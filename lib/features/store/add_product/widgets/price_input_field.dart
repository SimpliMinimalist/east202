import 'package:flutter/material.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';

class PriceInputField extends StatefulWidget {
  final TextEditingController priceController;
  final TextEditingController salePriceController;
  final VoidCallback onSalePriceTapped;
  final FocusNode? priceFocusNode;
  final String? discountPercentage;

  const PriceInputField({
    super.key,
    required this.priceController,
    required this.salePriceController,
    required this.onSalePriceTapped,
    this.priceFocusNode,
    this.discountPercentage,
  });

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
  bool _isPriceEntered = false;

  bool get _hasSalePrice =>
      widget.salePriceController.text.isNotEmpty &&
      double.tryParse(widget.salePriceController.text) != null;

  @override
  void initState() {
    super.initState();
    widget.priceController.addListener(_updateState);
    widget.salePriceController.addListener(_updateState);
    _updateState();
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_updateState);
    widget.salePriceController.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      final newPriceEntered = widget.priceController.text.isNotEmpty &&
          double.tryParse(widget.priceController.text) != null &&
          double.parse(widget.priceController.text) > 0;

      final newHasSalePrice = widget.salePriceController.text.isNotEmpty &&
          double.tryParse(widget.salePriceController.text) != null;

      if (newPriceEntered != _isPriceEntered || newHasSalePrice != _hasSalePrice) {
        setState(() {
          _isPriceEntered = newPriceEntered;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSalePrice) {
      return GestureDetector(
        onTap: widget.onSalePriceTapped,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Enter Price',
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
              const SizedBox(width: 4),
              if (widget.discountPercentage != null)
                Text(
                  widget.discountPercentage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const Spacer(),
              TextButton.icon(
                onPressed: widget.onSalePriceTapped,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit discount'),
              ),
            ],
          ),
        ),
      );
    } else {
      return ClearableTextFormField(
        controller: widget.priceController,
        focusNode: widget.priceFocusNode,
        labelText: 'Enter Price',
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
        suffixIcon: TextButton.icon(
          onPressed: _isPriceEntered ? widget.onSalePriceTapped : null,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add discount'),
        ),
      );
    }
  }
}
