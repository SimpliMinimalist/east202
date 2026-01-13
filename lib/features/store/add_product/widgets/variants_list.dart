import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/features/store/add_product/models/product_variant_model.dart';
import 'package:myapp/features/store/add_product/screens/edit_variant_screen.dart';

class VariantsList extends StatelessWidget {
  final List<ProductVariant> variants;
  final Function(int, ProductVariant) onVariantUpdated;

  const VariantsList({
    super.key,
    required this.variants,
    required this.onVariantUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        final variant = variants[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: variant.image != null
                ? Image.file(
                    File(variant.image!),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, color: Colors.grey, size: 40),
            title: Text(variant.name),
            subtitle: Text(
              '₹${variant.price.toStringAsFixed(2)} • ${variant.stock} available',
              style: TextStyle(
                color: variant.stock > 0 ? Colors.green : Colors.red,
              ),
            ),
            onTap: () async {
              final result = await Navigator.push<ProductVariant>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditVariantScreen(variant: variant),
                ),
              );
              if (result != null) {
                onVariantUpdated(index, result);
              }
            },
          ),
        );
      },
    );
  }
}
