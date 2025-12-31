import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final VoidCallback? onBack;
  final bool hasBackButton;
  final List<Widget>? trailing;
  final bool readOnly;
  final bool autoFocus;

  const CustomSearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.onTap,
    this.onClear,
    this.onBack,
    this.hasBackButton = true,
    this.trailing,
    this.readOnly = false,
    this.autoFocus = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          prefixIcon: widget.hasBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black54,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          suffixIcon: (widget.controller?.text.isNotEmpty ?? false)
              ? IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/cancel.svg',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: widget.onClear ??
                      () {
                        widget.controller?.clear();
                        widget.onChanged?.call('');
                      },
                )
              : null,
        ),
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        autofocus: widget.autoFocus,
      ),
    );
  }
}
