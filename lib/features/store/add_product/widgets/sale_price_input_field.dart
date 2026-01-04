import 'package:flutter/material.dart';

class SalePriceInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? prefixText;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const SalePriceInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixText,
    this.validator,
    this.autovalidateMode,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: prefixText,
        suffix: suffix,
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                },
              )
            : null,
      ),
    );
  }
}
