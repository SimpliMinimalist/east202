import 'package:myapp/features/store/add_product/models/product_model.dart';
import 'package:myapp/features/store/add_product/models/product_variant_model.dart';
import 'package:myapp/features/store/add_product/models/variant_model.dart';
import 'package:myapp/features/store/add_product/screens/add_variants_screen.dart';
import 'package:myapp/features/store/add_product/widgets/price_input_field.dart';
import 'package:myapp/features/store/add_product/widgets/product_image_handler.dart';
import 'package:myapp/features/store/add_product/widgets/sale_price_bottom_sheet.dart';
import 'package:myapp/features/store/add_product/widgets/variants_list.dart';
import 'package:myapp/features/store/widgets/add_category_bottom_sheet.dart';
import 'package:myapp/features/store/providers/category_provider.dart';
import 'package:myapp/features/store/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/shared/widgets/clearable_text_form_field.dart';
import 'package:myapp/features/store/add_product/widgets/drafts_popup.dart';
import 'package:myapp/features/store/add_product/widgets/stock_input_field.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  const AddProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageFieldKey = GlobalKey<FormFieldState<List<XFile>>>();
  final List<XFile> _images = [];

  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();

  Product? _initialProduct;
  late Product _editedProduct;
  String _discountPercentage = '';

  @override
  void initState() {
    super.initState();
    _initialProduct = widget.product?.copyWith();
    _editedProduct = widget.product?.copyWith() ??
        Product(
          id: const Uuid().v4(),
          name: '',
          price: 0.0,
          images: [],
          categories: [],
          isDraft: true,
        );

    if (widget.product != null) {
      _loadProductData(widget.product!);
    }

    _productNameController.addListener(_onFormChanged);
    _priceController.addListener(_onFormChanged);
    _salePriceController.addListener(_onFormChanged);
    _stockController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _salePriceController.addListener(_calculateDiscount);
    _calculateDiscount();
  }

  @override
  void dispose() {
    _productNameController.removeListener(_onFormChanged);
    _priceController.removeListener(_onFormChanged);
    _salePriceController.removeListener(_onFormChanged);
    _stockController.removeListener(_onFormChanged);
    _descriptionController.removeListener(_onFormChanged);
    _salePriceController.removeListener(_calculateDiscount);
    _productNameController.dispose();
    _priceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      _editedProduct = _editedProduct.copyWith(
        name: _productNameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text),
        salePrice: double.tryParse(_salePriceController.text),
        stock: int.tryParse(_stockController.text),
        images: _images.map((image) => image.path).toList(),
      );
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

  void _loadProductData(Product product) {
    _initialProduct = product.copyWith();
    _editedProduct = product.copyWith();
    _productNameController.text = product.name;
    _descriptionController.text = product.description ?? '';

    if (product.isDraft && product.price == 0.0) {
      _priceController.text = '';
    } else {
      _priceController.text = product.price.toString();
    }

    _salePriceController.text = product.salePrice?.toString() ?? '';
    _stockController.text = product.stock?.toString() ?? '';
    _images.clear();
    _images.addAll(product.images.map((path) => XFile(path)));
    _calculateDiscount();

    Provider.of<ProductProvider>(context, listen: false)
        .setSelectedDraftId(product.id);

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  bool _isFormModified() {
    return !(_initialProduct?.equals(_editedProduct) ?? false);
  }

  Future<void> _showSaveDraftDialog() async {
    final navigator = Navigator.of(context);
    if (!_isFormModified()) {
      navigator.pop();
      return;
    }

    final isEditingDraft = _initialProduct != null && _initialProduct!.isDraft;
    final isNewProduct = _initialProduct == null;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        if (isEditingDraft) {
          return AlertDialog(
            title: const Text('Save changes?'),
            content: const Text('Do you want to save the changes to this draft?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('discard'),
                child: const Text('Discard'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('continue'),
                child: const Text('Continue editing'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('save'),
                child: const Text('Save'),
              ),
            ],
          );
        } else if (isNewProduct) {
          return AlertDialog(
            title: const Text('Save changes?'),
            content: const Text('Do you want to save this product as a draft?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('discard'),
                child: const Text('Discard'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('continue'),
                child: const Text('Continue editing'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('save'),
                child: const Text('Save as Draft'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('continue'),
                child: const Text('Continue editing'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('discard'),
                child: const Text('Discard'),
              ),
            ],
          );
        }
      },
    );

    if (!mounted) return;

    if (result == 'save') {
      final bool didSave = _saveDraft();
      if (didSave) {
        Navigator.of(context).pop();
      }
    } else if (result == 'discard') {
      Provider.of<ProductProvider>(context, listen: false).clearSelection();
      Navigator.of(context).pop();
    }
  }

  bool _saveDraft() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (productProvider.drafts.length >= 5 &&
        (_initialProduct == null || !_initialProduct!.isDraft)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Drafts Limit Reached'),
          content: const Text(
              'You can only save up to 5 drafts. Please delete an existing draft to save a new one.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }

    final draftProduct = _editedProduct.copyWith(isDraft: true);

    productProvider.saveDraft(draftProduct);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved as draft!')),
      );
    }
    return true;
  }

  void _showDraftsPopup() async {
    final selectedDraft = await showGeneralDialog<Product>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withAlpha(102),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: DraftsPopup(),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );

    if (selectedDraft != null) {
      if (_isFormModified()) {
        final result = await _showLoadConfirmationDialog();
        if (result == 'save_draft') {
          final didSave = _saveDraft();
          if (didSave && mounted) {
            _loadProductData(selectedDraft);
          }
        } else if (result == 'discard') {
          if (mounted) {
            _loadProductData(selectedDraft);
          }
        }
      } else {
        if (mounted) {
          _loadProductData(selectedDraft);
        }
      }
    }
  }

  Future<String?> _showLoadConfirmationDialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You have unsaved changes'),
          content: const Text(
              'Do you want to save your current work as a draft before loading the new one?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop('cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('discard'),
              child: const Text('Discard & Load'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('save_draft'),
              child: const Text('Save as Draft & Load'),
            ),
          ],
        );
      },
    );
  }

  void _attemptSave() {
    if (_formKey.currentState!.validate()) {
      final navigator = Navigator.of(context);
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      final productToSave = _editedProduct.copyWith(isDraft: false);

      if (_initialProduct == null || _initialProduct!.isDraft) {
        productProvider.addProduct(productToSave);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        }
      } else {
        productProvider.updateProduct(productToSave);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
        }
      }
      if (mounted) {
        navigator.pop();
      }
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...categoryProvider.categories.map((category) {
                        return CheckboxListTile(
                          title: Text(category),
                          value: _editedProduct.categories.contains(category),
                          onChanged: (bool? value) {
                            setState(() {
                              final newCategories =
                                  List<String>.from(_editedProduct.categories);
                              if (value == true) {
                                newCategories.add(category);
                              } else {
                                newCategories.remove(category);
                              }
                              this.setState(() {
                                _editedProduct = _editedProduct.copyWith(
                                    categories: newCategories);
                              });
                            });
                          },
                        );
                      }),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Add New Category'),
                        onTap: () {
                          Navigator.pop(context);
                          showAddCategoryBottomSheet(context);
                        },
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });
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

  List<ProductVariant> _generateVariants(List<VariantOption> options) {
    if (options.isEmpty) {
      return [];
    }

    List<ProductVariant> newVariants = [];
    final valueLists = options.map((o) => o.values).toList();
    final combinations = _getCombinations(valueLists);

    for (var combination in combinations) {
      final attributes = <String, String>{};
      for (int i = 0; i < options.length; i++) {
        attributes[options[i].name] = combination[i];
      }

      final existingVariant = _editedProduct.productVariants.firstWhere(
        (v) =>
            v.attributes.entries.every((e) => attributes[e.key] == e.value),
        orElse: () => ProductVariant(attributes: attributes),
      );

      newVariants.add(existingVariant.copyWith(attributes: attributes));
    }

    return newVariants;
  }

  List<List<T>> _getCombinations<T>(List<List<T>> lists) {
    List<List<T>> result = [[]];
    for (var list in lists) {
      List<List<T>> newResult = [];
      for (var res in result) {
        for (var item in list) {
          newResult.add([...res, item]);
        }
      }
      result = newResult;
    }
    return result;
  }

  List<XFile> _getVariantImages() {
    return _editedProduct.productVariants
        .expand((variant) => variant.images.map((path) => XFile(path)))
        .toList();
  }

  List<String> _getVariantImageLabels() {
    return _editedProduct.productVariants
        .expand((variant) => List.filled(
            variant.images.length, variant.attributes.values.join(' / ')))
        .toList();
  }

  void _deleteVariantImage(XFile imageFile) {
    setState(() {
      _editedProduct = _editedProduct.copyWith(
        productVariants: _editedProduct.productVariants.map((variant) {
          final newImages = List<String>.from(variant.images);
          newImages.remove(imageFile.path);
          return variant.copyWith(images: newImages);
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.titleLarge;
    final isEditing = _initialProduct != null && !_initialProduct!.isDraft;
    final isDraft = _initialProduct != null && _initialProduct!.isDraft;
    final hasVariants = _editedProduct.productVariants.isNotEmpty;

    return PopScope(
      canPop: !_isFormModified(),
      onPopInvokedWithResult: (bool didPop, bool? result) async {
        if (didPop) {
          Provider.of<ProductProvider>(context, listen: false).clearSelection();
          return;
        }
        _showSaveDraftDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _showSaveDraftDialog,
          ),
          title: Text(
            isEditing
                ? 'Edit Product'
                : (isDraft ? 'Edit Draft' : 'New Product'),
            style: titleTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: (titleTextStyle.fontSize ?? 22.0) - 1.0,
            ),
          ),
          actions: [
            if (!isEditing)
              IconButton(
                icon: SvgPicture.asset('assets/icons/draft_products.svg',
                    width: 24, height: 24),
                onPressed: _showDraftsPopup,
              ),
          ],
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageHandler(
                  initialImages: hasVariants ? _getVariantImages() : _images,
                  imageLabels: hasVariants ? _getVariantImageLabels() : null,
                  onImagesChanged: (newImages) {
                    if (!hasVariants) {
                      setState(() {
                        _images.clear();
                        _images.addAll(newImages);
                        _editedProduct = _editedProduct.copyWith(
                          images: _images.map((image) => image.path).toList(),
                        );
                      });
                    }
                  },
                  onImageDeleted: hasVariants ? _deleteVariantImage : null,
                  imageFieldKey: _imageFieldKey,
                  maxImages: 10,
                  isVariantGallery: hasVariants,
                ),
                const SizedBox(height: 24),
                ClearableTextFormField(
                  controller: _productNameController,
                  labelText: 'Product Name',
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if (_editedProduct.productVariants.isEmpty) ...[
                  const SizedBox(height: 16),
                  PriceInputField(
                    priceController: _priceController,
                    salePriceController: _salePriceController,
                    onSalePriceTapped: _showSalePriceBottomSheet,
                    discountPercentage: _discountPercentage,
                  ),
                ],
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showCategoryPicker,
                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: _editedProduct.categories.isEmpty ? '' : ' '),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                        prefixIcon: _editedProduct.categories.isEmpty
                            ? null
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 8, 0, 8),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: _editedProduct.categories
                                      .map((category) {
                                    return Chip(
                                      label: Text(category),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      visualDensity:
                                          const VisualDensity(vertical: -2),
                                    );
                                  }).toList(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                if (_editedProduct.productVariants.isEmpty) ...[
                  const SizedBox(height: 16),
                  StockInputField(
                    controller: _stockController,
                    labelText: 'Stock',
                  ),
                ],
                const SizedBox(height: 16),
                ClearableTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  maxLength: 300,
                  maxLines: 3,
                  expandOnFocus: true,
                ),
                const SizedBox(height: 16),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push<List<VariantOption>>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddVariantsScreen(
                            initialVariants: _editedProduct.variants,
                          ),
                        ),
                      );
                      if (result != null) {
                        final newProductVariants = _generateVariants(result);
                        setState(() {
                          _editedProduct = _editedProduct.copyWith(
                            variants: result,
                            productVariants: newProductVariants,
                          );
                        });
                      }
                    },
                    icon: Icon(_editedProduct.productVariants.isEmpty
                        ? Icons.add
                        : Icons.edit),
                    label: Text(_editedProduct.productVariants.isEmpty
                        ? 'Add Product Variants'
                        : 'Edit Product Variants'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                    ),
                  ),
                ),
                if (_editedProduct.productVariants.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  VariantsList(
                    variants: _editedProduct.productVariants,
                    onVariantUpdated: (index, updatedVariant) {
                      setState(() {
                        final newVariants = List<ProductVariant>.from(
                            _editedProduct.productVariants);
                        newVariants[index] = updatedVariant;
                        _editedProduct = _editedProduct.copyWith(
                          productVariants: newVariants,
                        );
                      });
                    },
                  ),
                ]
              ],
            ),
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
                    onPressed: _attemptSave,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(isEditing
                        ? 'Update Product'
                        : (isDraft ? 'Add Product' : 'Add Product')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
