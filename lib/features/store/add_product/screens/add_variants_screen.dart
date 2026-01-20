import 'package:flutter/material.dart';
import 'package:myapp/features/store/add_product/models/variant_model.dart';

class AddVariantsScreen extends StatefulWidget {
  final List<VariantOption> initialVariants;
  final bool isUpdating;

  const AddVariantsScreen({
    super.key,
    this.initialVariants = const [],
    this.isUpdating = false,
  });

  @override
  State<AddVariantsScreen> createState() => _AddVariantsScreenState();
}

class _AddVariantsScreenState extends State<AddVariantsScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _optionControllers = [];
  final List<List<TextEditingController>> _valueControllers = [];
  final List<FocusNode> _optionFocusNodes = [];
  final List<List<FocusNode>> _valueFocusNodes = [];
  final List<String> _optionPlaceholders = ['Size', 'Color', 'Material'];
  final List<List<String>> _valuePlaceholders = [
    ['Small', 'Medium', 'Large'],
    ['Red', 'Blue', 'Green'],
    ['Cotton', 'Silk', 'Nylon']
  ];

  late List<VariantOption> _originalVariants;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _originalVariants = widget.initialVariants.map((v) => VariantOption(name: v.name, values: List.from(v.values))).toList();
    if (widget.initialVariants.isNotEmpty) {
      _loadInitialVariants();
    } else {
      _addOption();
    }
  }

  void _loadInitialVariants() {
    for (var variant in widget.initialVariants) {
      final optionController = TextEditingController(text: variant.name);
      final focusNode = FocusNode();
      _optionControllers.add(optionController);
      _optionFocusNodes.add(focusNode);
      focusNode.addListener(_onFocusChange);
      optionController.addListener(_checkForChanges);

      final valueControllersForOption = <TextEditingController>[];
      final valueFocusNodesForOption = <FocusNode>[];
      for (var value in variant.values) {
        final valueController = TextEditingController(text: value);
        valueController.addListener(_checkForChanges);
        valueControllersForOption.add(valueController);
        valueFocusNodesForOption.add(FocusNode());
      }
      _valueControllers.add(valueControllersForOption);
      _valueFocusNodes.add(valueFocusNodesForOption);
    }
    setState(() {});
  }

  void _checkForChanges() {
    bool changed = false;
    if (_optionControllers.length != _originalVariants.length) {
      changed = true;
    } else {
      for (int i = 0; i < _optionControllers.length; i++) {
        if (_optionControllers[i].text != _originalVariants[i].name) {
          changed = true;
          break;
        }
        if (_valueControllers[i].length != _originalVariants[i].values.length) {
          changed = true;
          break;
        }
        for (int j = 0; j < _valueControllers[i].length; j++) {
          if (_valueControllers[i][j].text != _originalVariants[i].values[j]) {
            changed = true;
            break;
          }
        }
        if (changed) break;
      }
    }
    setState(() {
      _isDirty = changed;
    });
  }

  void _addOption() {
    if (_optionControllers.length < 3) {
      final optionController = TextEditingController();
      optionController.addListener(_checkForChanges);
      final focusNode = FocusNode(); 
      final valueController = TextEditingController();
      valueController.addListener(_checkForChanges);

      setState(() {
        _optionControllers.add(optionController);
        _valueControllers.add([valueController]);
        _optionFocusNodes.add(focusNode); 
        _valueFocusNodes.add([FocusNode()]);
      });
      focusNode.addListener(_onFocusChange);
      _checkForChanges();
    }
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _addValue(int optionIndex) {
    final newFocusNode = FocusNode();
    final newValueController = TextEditingController();
    newValueController.addListener(_checkForChanges);
    setState(() {
      _valueControllers[optionIndex].add(newValueController);
      _valueFocusNodes[optionIndex].add(newFocusNode);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(newFocusNode);
    });
    _checkForChanges();
  }

  void _removeOption(int optionIndex) {
    _optionControllers[optionIndex].dispose();
    for (var controller in _valueControllers[optionIndex]) {
      controller.dispose();
    }
    for (var focusNode in _valueFocusNodes[optionIndex]) {
      focusNode.dispose();
    }
    _optionFocusNodes[optionIndex].removeListener(_onFocusChange);
    _optionFocusNodes[optionIndex].dispose();

    setState(() {
      _optionControllers.removeAt(optionIndex);
      _valueControllers.removeAt(optionIndex);
      _optionFocusNodes.removeAt(optionIndex);
      _valueFocusNodes.removeAt(optionIndex);
    });
    _checkForChanges();
  }

  void _removeValue(int optionIndex, int valueIndex) {
    _valueControllers[optionIndex][valueIndex].dispose();
    _valueFocusNodes[optionIndex][valueIndex].dispose();
    setState(() {
      _valueControllers[optionIndex].removeAt(valueIndex);
      _valueFocusNodes[optionIndex].removeAt(valueIndex);
    });
    _checkForChanges();
  }

  @override
  void dispose() {
    for (var controller in _optionControllers) {
      controller.removeListener(_checkForChanges);
      controller.dispose();
    }
    for (var valueList in _valueControllers) {
      for (var controller in valueList) {
        controller.removeListener(_checkForChanges);
        controller.dispose();
      }
    }
    for (var focusNode in _optionFocusNodes) {
      focusNode.removeListener(_onFocusChange);
      focusNode.dispose();
    }
    for (var focusNodeList in _valueFocusNodes) {
      for (var focusNode in focusNodeList) {
        focusNode.dispose();
      }
    }
    super.dispose();
  }

  bool _isFormSufficient() {
    return _optionControllers.any((optCtrl) {
      if (optCtrl.text.trim().isEmpty) return false;
      int index = _optionControllers.indexOf(optCtrl);
      return _valueControllers[index].any((valCtrl) => valCtrl.text.trim().isNotEmpty);
    });
  }

  void _saveVariants() {
    if (_formKey.currentState!.validate()) {
      if (_isFormSufficient()) {
        final variants = <VariantOption>[];
        for (int i = 0; i < _optionControllers.length; i++) {
          final optionName = _optionControllers[i].text.trim();
          if (optionName.isNotEmpty) {
            final values = _valueControllers[i]
                .map((controller) => controller.text.trim())
                .where((value) => value.isNotEmpty)
                .toList();
            if (values.isNotEmpty) {
              variants.add(VariantOption(name: optionName, values: values));
            }
          }
        }
        Navigator.pop(context, variants);
      }
    }
  }

  void _deleteAllVariants() {
    Navigator.pop(context, <VariantOption>[]);
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Variants'),
        content: const Text('Are you sure you want to delete all the variants?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      _deleteAllVariants();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSaveEnabled = _isFormSufficient() && (widget.isUpdating ? _isDirty : true);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdating ? 'Edit Variants' : 'Add Variants'),
        actions: [
          if (widget.isUpdating)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showDeleteConfirmationDialog,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ..._buildVariantFields(),
              if (_optionControllers.length < 3)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addOption,
                    icon: const Icon(Icons.add),
                    label: const Text('Add another option'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                'In the next step, you will add images, prices, and stock for each variant.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
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
                  onPressed: isSaveEnabled ? _saveVariants : null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isSaveEnabled
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    foregroundColor:
                        isSaveEnabled ? Colors.white : Colors.grey.shade600,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildVariantFields() {
    List<Widget> fields = [];
    for (int i = 0; i < _optionControllers.length; i++) {
      final bool isFocused = _optionFocusNodes[i].hasFocus;
      final bool hasText = _optionControllers[i].text.isNotEmpty;
      final String currentPlaceholder = (i < _optionPlaceholders.length)
          ? _optionPlaceholders[i]
          : 'Custom';

      final String dynamicLabelText = (isFocused || hasText)
          ? 'Option name'
          : 'Option name e.g., $currentPlaceholder';

      fields.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Option ${i + 1}',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (_optionControllers.length > 1)
                    IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeOption(i))
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _optionControllers[i],
                focusNode: _optionFocusNodes[i],
                decoration: InputDecoration(
                  labelText: dynamicLabelText,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Option name is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              Text('Values (${_valueControllers[i].length})',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ..._buildValueFields(i),
                    const Divider(height: 1),
                    InkWell(
                      onTap: () => _addValue(i),
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('Add value'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return fields;
  }

  List<Widget> _buildValueFields(int optionIndex) {
    List<Widget> valueFields = [];
    for (int j = 0; j < _valueControllers[optionIndex].length; j++) {
      final String hintText = (optionIndex < _valuePlaceholders.length &&
              j < _valuePlaceholders[optionIndex].length)
          ? 'e.g., ${_valuePlaceholders[optionIndex][j]}'
          : 'Value';

      valueFields.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.drag_handle, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _valueControllers[optionIndex][j],
                focusNode: _valueFocusNodes[optionIndex][j],
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Value is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ),
            if (_valueControllers[optionIndex].length > 1)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => _removeValue(optionIndex, j),
              ),
          ],
        ),
      ));
      if (j < _valueControllers[optionIndex].length - 1) {
        valueFields.add(const Divider(height: 1, indent: 12, endIndent: 12));
      }
    }
    return valueFields;
  }
}