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
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool forceFocus;

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
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.focusNode,
    this.forceFocus = false,
  });

  @override
  State<ClearableTextFormField> createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _didCreateFocusNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _didCreateFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    if (_didCreateFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final bool shouldAppearFocused = widget.forceFocus || _isFocused;
    final bool hasText = widget.controller.text.isNotEmpty;

    final FloatingLabelBehavior floatingLabelBehavior;
    if (shouldAppearFocused || hasText) {
      floatingLabelBehavior = FloatingLabelBehavior.always;
    } else {
      floatingLabelBehavior = FloatingLabelBehavior.auto;
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: shouldAppearFocused ? TextStyle(color: primaryColor) : null,
        hintText: widget.hintText,
        floatingLabelBehavior: floatingLabelBehavior,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        enabledBorder: widget.forceFocus
            ? OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 2.0),
              )
            : null,
        prefixText: widget.prefixText,
        suffixIcon: widget.suffixIcon ??
            (shouldAppearFocused && hasText && !widget.readOnly
                ? IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/cancel.svg',
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
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
