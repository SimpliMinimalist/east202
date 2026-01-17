import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/features/store/add_product/models/product_variant_model.dart';
import 'package:myapp/features/store/add_product/screens/edit_variant_screen.dart';

class VariantsList extends StatelessWidget {
  final List<ProductVariant> variants;
  final Function(int, ProductVariant) onVariantUpdated;
  final Function(int) onVariantDeleted;

  const VariantsList({
    super.key,
    required this.variants,
    required this.onVariantUpdated,
    required this.onVariantDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        final variant = variants[index];
        final bool hasSalePrice = variant.salePrice != null &&
            variant.salePrice! > 0 &&
            variant.salePrice! < variant.price;
        final stockColor = variant.stock > 0 ? Colors.green : Colors.red;

        Widget subtitleWidget;
        if (hasSalePrice) {
          final double discount =
              ((variant.price - variant.salePrice!) / variant.price) * 100;
          subtitleWidget = RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <InlineSpan>[
                TextSpan(
                  text: '₹${variant.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: ' ₹${variant.salePrice!.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black),
                ),
                TextSpan(
                  text: ' (${discount.toStringAsFixed(0)}% off)',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' • ${variant.stock} available',
                  style: TextStyle(color: stockColor, fontSize: 12),
                ),
              ],
            ),
          );
        } else {
          subtitleWidget = Text(
            '₹${variant.price.toStringAsFixed(2)} • ${variant.stock} available',
            style: TextStyle(
              color: stockColor,
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: variant.images.isNotEmpty
                ? Image.file(
                    File(variant.images.first),
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image, color: Colors.grey, size: 40),
            title: Text(variant.name),
            subtitle: subtitleWidget,
            trailing: Transform.translate(
              offset: const Offset(8, 0), // Move the icon 8 pixels to the right
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Variant?'),
                        content: const Text(
                            'Are you sure you want to delete this variant? This action cannot be undone.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              onVariantDeleted(index);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditVariantScreen(variant: variant),
                ),
              );
              if (result != null) {
                if (result == 'DELETE') {
                  onVariantDeleted(index);
                } else if (result is ProductVariant) {
                  onVariantUpdated(index, result);
                }
              }
            },
          ),
        );
      },
    );
  }
}
