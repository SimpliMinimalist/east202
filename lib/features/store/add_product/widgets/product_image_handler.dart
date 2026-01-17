import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductImageHandler extends StatefulWidget {
  final List<XFile> initialImages;
  final Function(List<XFile>) onImagesChanged;
  final GlobalKey<FormFieldState<List<XFile>>>? imageFieldKey;
  final int maxImages;
  final String? errorMessage;
  final bool isVariantGallery;

  const ProductImageHandler({
    super.key,
    required this.initialImages,
    required this.onImagesChanged,
    this.imageFieldKey,
    this.maxImages = 10,
    this.errorMessage,
    this.isVariantGallery = false,
  });

  @override
  State<ProductImageHandler> createState() => _ProductImageHandlerState();
}

class _ProductImageHandlerState extends State<ProductImageHandler> {
  late List<XFile> _images;
  int _activePage = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  @override
  void didUpdateWidget(covariant ProductImageHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImages != oldWidget.initialImages) {
      setState(() {
        _images = List.from(widget.initialImages);
        if (_images.isNotEmpty && _activePage >= _images.length) {
          _activePage = _images.length - 1;
        }
      });
    }
  }

  Future<void> _pickImages() async {
    if (widget.isVariantGallery) return;
    final messenger = ScaffoldMessenger.of(context);
    if (_images.length >= widget.maxImages) {
      messenger.showSnackBar(
        SnackBar(
            content: Text(
                'You can only select up to ${widget.maxImages} images.')),
      );
      return;
    }

    if (widget.maxImages - _images.length == 1) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _images.add(pickedFile);
          widget.onImagesChanged(_images);
        });
      }
    } else {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        limit: widget.maxImages - _images.length,
      );
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _images.addAll(pickedFiles);
          widget.onImagesChanged(_images);
        });
      }
    }
    widget.imageFieldKey?.currentState?.validate();
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isNotEmpty && _activePage >= _images.length) {
        _activePage = _images.length - 1;
      }
      widget.onImagesChanged(_images);
    });
    widget.imageFieldKey?.currentState?.validate();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorMessage != null && widget.errorMessage!.isNotEmpty;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _images.isEmpty
            ? _buildAddPhotoImage(hasError)
            : _buildImageCarousel(),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              widget.errorMessage!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );

    if (widget.imageFieldKey != null) {
      return FormField<List<XFile>>(
        key: widget.imageFieldKey,
        initialValue: _images,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.maxImages > 1 && _images.isEmpty && !widget.isVariantGallery) {
            return 'Please select at least one image.';
          }
          return null;
        },
        builder: (formFieldState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _images.isEmpty
                  ? _buildAddPhotoImage(formFieldState.hasError)
                  : _buildImageCarousel(),
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                  child: Text(
                    formFieldState.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }
    return content;
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.0,
          child: CarouselSlider.builder(
            itemCount: _images.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_images[index].path),
                        fit: BoxFit.cover,
                      ),
                      if (widget.maxImages > 1)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(128),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              '${index + 1}/${_images.length}',
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(128),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _activePage = index;
                });
              },
            ),
          ),
        ),
        if (widget.maxImages > 1) ...[
          const SizedBox(height: 12),
          if (_images.length > 1)
            Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _activePage,
                count: _images.length,
                effect: ScrollingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: Theme.of(context).primaryColor,
                  dotColor: Colors.grey,
                  maxVisibleDots: 5,
                ),
              ),
            ),
          const SizedBox(height: 12),
        ],
        if (_images.length < widget.maxImages && !widget.isVariantGallery)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(widget.maxImages > 1 ? 'Add More Photos' : 'Add Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                elevation: 0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddPhotoImage(bool hasError) {
    final backgroundColor = hasError
        ? Theme.of(context).colorScheme.error.withAlpha(25)
        : Colors.white;

    final label = widget.isVariantGallery
        ? 'Variant images will be shown here'
        : widget.maxImages > 1
            ? 'Add up to ${widget.maxImages} Photos'
            : 'Add a Photo';

    return AspectRatio(
      aspectRatio: 1 / 1,
      child: InkWell(
        onTap: _pickImages,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isVariantGallery ? Icons.image : Icons.add_a_photo_outlined,
                  size: 64,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
