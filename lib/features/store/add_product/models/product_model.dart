import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import './product_variant_model.dart';
import './variant_model.dart';

@immutable
class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? salePrice;
  final int? stock;
  final List<String> images;
  final List<String> categories;
  final bool isDraft;
  final DateTime? savedAt;
  final List<VariantOption> variants;
  final List<ProductVariant> productVariants;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.salePrice,
    this.stock,
    this.images = const [],
    this.categories = const [],
    this.isDraft = false,
    this.savedAt,
    this.variants = const [],
    this.productVariants = const [],
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? salePrice,
    int? stock,
    List<String>? images,
    List<String>? categories,
    bool? isDraft,
    DateTime? savedAt,
    List<VariantOption>? variants,
    List<ProductVariant>? productVariants,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      stock: stock ?? this.stock,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      isDraft: isDraft ?? this.isDraft,
      savedAt: savedAt ?? this.savedAt,
      variants: variants ?? this.variants,
      productVariants: productVariants ?? this.productVariants,
    );
  }
}

extension ProductEquals on Product {
  bool equals(Product other) {
    const listEquals = ListEquality();
    const productVariantEquality = ListEquality(ProductVariantEquality());

    return id == other.id &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        salePrice == other.salePrice &&
        stock == other.stock &&
        listEquals.equals(categories, other.categories) &&
        listEquals.equals(images, other.images) &&
        listEquals.equals(variants, other.variants) &&
        productVariantEquality.equals(productVariants, other.productVariants);
  }
}

class ProductVariantEquality implements Equality<ProductVariant> {
  const ProductVariantEquality();

  @override
  bool equals(ProductVariant e1, ProductVariant e2) {
    return e1.id == e2.id &&
        e1.price == e2.price &&
        e1.stock == e2.stock &&
        const MapEquality().equals(e1.attributes, e2.attributes);
  }

  @override
  int hash(ProductVariant e) {
    return e.id.hashCode ^
        e.price.hashCode ^
        e.stock.hashCode ^
        const MapEquality().hash(e.attributes);
  }

  @override
  bool isValidKey(Object? o) => o is ProductVariant;
}
