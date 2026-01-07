import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClearableTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? prefixText;
  final bool readOnly;
  final VoidCallback? onTap;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final TextInputType? keyboardType;
  final bool forceFocus;
  final Widget? suffixIcon;
  final String? suffixText;
  final FocusNode? focusNode;
  final int? maxLines;

  const ClearableTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixText,
    this.readOnly = false,
    this.onTap,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.autovalidateMode,
    this.keyboardType,
    this.forceFocus = false,
    this.suffixIcon,
    this.suffixText,
    this.focusNode,
    this.maxLines,
  });

  @override
  State<ClearableTextFormField> createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
    _hasText = widget.controller.text.isNotEmpty;
    if (widget.forceFocus) {
      _hasFocus = true;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      // Only dispose the focus node if it was created internally.
      _focusNode.dispose();
    }
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.forceFocus) {
      if (!_hasFocus) {
        setState(() => _hasFocus = true);
      }
    } else {
      setState(() => _hasFocus = _focusNode.hasFocus);
    }
  }

  void _onTextChange() {
    setState(() => _hasText = widget.controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bool shouldAppearFocused = _hasFocus || widget.forceFocus;

    final floatingLabelBehavior =
        (shouldAppearFocused || _hasText || widget.prefixText != null)
            ? FloatingLabelBehavior.auto
            : FloatingLabelBehavior.never;

    final clearIcon = (shouldAppearFocused && _hasText && !widget.readOnly)
        ? IconButton(
            icon: SvgPicture.asset(
              'assets/icons/cancel.svg',
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
            ),
            onPressed: () {
              widget.controller.clear();
              widget.onChanged?.call('');
            },
            tooltip: 'Clear',
          )
        : null;

    final suffixTextWidget = (widget.suffixText?.isNotEmpty ?? false)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.suffixText!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : null;

    Widget? finalSuffixWidget;
    if (widget.suffixIcon != null) {
      finalSuffixWidget = widget.suffixIcon;
    } else if (suffixTextWidget != null || clearIcon != null) {
      finalSuffixWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (suffixTextWidget != null) suffixTextWidget,
          if (clearIcon != null) clearIcon,
        ],
      );
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      buildCounter: (context,
          {required currentLength, required isFocused, required maxLength}) {
        if (isFocused && maxLength != null) {
          return Text(
            '$currentLength/$maxLength',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }
        return null;
      },
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
        suffixIcon: finalSuffixWidget,
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.keyboardType,
    );
  }
}
