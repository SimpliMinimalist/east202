import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClearableTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final int? maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const ClearableTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixText,
    this.keyboardType,
    this.validator,
    this.autovalidateMode,
    this.maxLines,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  State<ClearableTextFormField> createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        prefixText: widget.prefixText,
        suffixIcon: widget.suffixIcon ??
            (_isFocused && widget.controller.text.isNotEmpty && !widget.readOnly
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      width: 20,
                      height: 20,
                      colorFilter:
                          ColorFilter.mode(primaryColor, BlendMode.srcIn),
                    ),
                    onPressed: () {
                      widget.controller.clear();
                    },
                  )
                : null),
      ),
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      maxLines: widget.maxLines ?? (widget.readOnly ? null : 1),
    );
  }
}
