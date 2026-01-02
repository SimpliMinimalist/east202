
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const StockInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<StockInputField> createState() => _StockInputFieldState();
}

class _StockInputFieldState extends State<StockInputField> {
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
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onControllerChanged);
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

  void _onControllerChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  void _updateStock(int change) {
    int currentValue = int.tryParse(widget.controller.text) ?? 0;
    int newValue = currentValue + change;
    if (newValue >= 0) {
      widget.controller.text = newValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: _isFocused
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => _updateStock(-1),
                    tooltip: 'Decrease Stock',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _updateStock(1),
                    tooltip: 'Increase Stock',
                  ),
                ],
              )
            : null,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value != null &&
            value.isNotEmpty &&
            int.tryParse(value) == null) {
          return 'Please enter a valid integer';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
