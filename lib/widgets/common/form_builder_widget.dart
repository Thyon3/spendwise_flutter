import 'package:flutter/material.dart';

enum FormFieldType {
  text,
  email,
  password,
  number,
  phone,
  url,
  textarea,
  dropdown,
  multiselect,
  checkbox,
  radio,
  date,
  time,
  file,
  switch,
  slider,
  custom,
}

enum FormFieldSize {
  small,
  medium,
  large,
}

enum FormFieldValidation {
  required,
  email,
  phone,
  url,
  minLength,
  maxLength,
  min,
  max,
  pattern,
  custom,
}

class FormField {
  final String key;
  final String label;
  final FormFieldType type;
  final FormFieldSize size;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool disabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final int? minLength;
  final double? min;
  final double? max;
  final String? pattern;
  final List<FormFieldOption>? options;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String?>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator? validator;
  final Widget? customWidget;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool enableInteractiveSelection;

  FormField({
    required this.key,
    required this.label,
    this.type = FormFieldType.text,
    this.size = FormFieldSize.medium,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.required = false,
    this.disabled = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.minLength,
    this.min,
    this.max,
    this.pattern,
    this.options,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.validator,
    this.customWidget,
    this.keyboardType,
    this.inputFormatters,
    this.autofocus = false,
    this.enableInteractiveSelection = true,
  });
}

class FormFieldOption {
  final String value;
  final String label;
  final Widget? icon;
  final bool disabled;

  const FormFieldOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });
}

typedef FormFieldValidator = String? Function(String? value);

class FormBuilderWidget extends StatefulWidget {
  final List<FormField> fields;
  final Map<String, dynamic>? initialValues;
  final bool autoValidate;
  final bool enabled;
  final EdgeInsets? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final Widget? submitButton;
  final Widget? cancelButton;
  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final bool showSubmitButton;
  final bool showCancelButton;
  final String submitButtonText;
  final String cancelButtonText;
  final bool isSubmitting;
  final GlobalKey<FormState>? formKey;
  final bool scrollable;
  final bool autoScroll;
  final Function(Map<String, dynamic>)? onFieldChanged;
  final Function(Map<String, dynamic>)? onSubmitPressed;

  const FormBuilderWidget({
    Key? key,
    required this.fields,
    this.initialValues,
    this.autoValidate = false,
    this.enabled = true,
    this.padding,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.submitButton,
    this.cancelButton,
    this.onSubmit,
    this.onCancel,
    this.showSubmitButton = true,
    this.showCancelButton = false,
    this.submitButtonText = 'Submit',
    this.cancelButtonText = 'Cancel',
    this.isSubmitting = false,
    this.formKey,
    this.scrollable = false,
    this.autoScroll = false,
    this.onFieldChanged,
    this.onSubmitPressed,
  }) : super(key: key);

  @override
  State<FormBuilderWidget> createState() => _FormBuilderWidgetState();
}

class _FormBuilderWidgetState extends State<FormBuilderWidget> {
  final GlobalKey<FormState> _formKey = widget.formKey ?? GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, String> _errors = {};
  final Map<String, dynamic> _values = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeValues();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _initializeControllers() {
    for (final field in widget.fields) {
      _controllers[field.key] = field.controller ?? TextEditingController();
      _focusNodes[field.key] = field.focusNode ?? FocusNode();
    }
  }

  void _initializeValues() {
    for (final field in widget.fields) {
      final initialValue = widget.initialValues?[field.key];
      if (initialValue != null) {
        _values[field.key] = initialValue;
        _controllers[field.key].text = initialValue.toString();
      }
    }
  }

  void _updateValue(String key, dynamic value) {
    setState(() {
      _values[key] = value;
      widget.onFieldChanged?.call(_values);
    });
  }

  String? _validateField(FormField field, String? value) {
    if (field.validator != null) {
      return field.validator(value);
    }

    if (field.required && (value == null || value.isEmpty)) {
      return '${field.label} is required';
    }

    switch (field.type) {
      case FormFieldType.email:
        if (value != null && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case FormFieldType.phone:
        if (value != null && !RegExp(r'^\+?\d{10,15}$').hasMatch(value.replaceAll(RegExp(r'[^\d+]'), ''))) {
          return 'Please enter a valid phone number';
        }
        break;
      case FormFieldType.url:
        if (value != null && !Uri.tryParse(value).hasScheme) {
          return 'Please enter a valid URL';
        }
        break;
      case FormFieldType.password:
        if (value != null && value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        break;
      case FormFieldType.number:
        if (value != null && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        if (field.min != null && value != null && double.tryParse(value)! < field.min) {
          return 'Value must be at least ${field.min}';
        }
        if (field.max != null && value != null && double.tryParse(value)! > field.max) {
          return 'Value must be at most ${field.max}';
        }
        break;
      case FormFieldType.text:
        if (field.minLength != null && value != null && value.length < field.minLength) {
          return 'Must be at least ${field.minLength} characters';
        }
        if (field.maxLength != null && value != null && value.length > field.maxLength) {
          return 'Must be at most ${field.maxLength} characters';
        }
        break;
      case FormFieldType.pattern:
        if (field.pattern != null && value != null && !RegExp(field.pattern).hasMatch(value)) {
          return 'Invalid format';
        }
        break;
    }

    return null;
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      _errors.clear();
    });

    for (final field in widget.fields) {
      final value = _controllers[field.key].text;
      final error = _validateField(field, value);
      if (error != null) {
        _errors[field.key] = error;
        isValid = false;
      }
    }

    return isValid;
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      return;
    }

    if (widget.onSubmitPressed != null) {
      widget.onSubmitPressed!(_values);
    }

    if (widget.onSubmit != null) {
      await widget.onSubmit(_values);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formContent = Column(
      crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Expanded(
          child: widget.scrollable
              ? SingleChildScrollView(
                  controller: ScrollController(),
                  child: _buildFormFields(),
                )
              : _buildFormFields(),
        ),
        if (widget.showSubmitButton || widget.showCancelButton)
          _buildActionButtons(),
      ],
    );

    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: widget.autoValidate,
        child: formContent,
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.fields.map((field) => _buildFormField(field)).toList(),
    );
  }

  Widget _buildFormField(FormField field) {
    switch (field.type) {
      case FormFieldType.text:
      case FormFieldType.email:
      case FormFieldType.password:
      case FormFieldType.phone:
      case FormFieldType.url:
        return _buildTextField(field);
      case FormFieldType.number:
        return _buildNumberField(field);
      case FormFieldType.textarea:
        return _buildTextAreaField(field);
      case FormFieldType.dropdown:
        return _buildDropdownField(field);
      case FormFieldType.multiselect:
        return _buildMultiSelectField(field);
      case FormFieldType.checkbox:
        return _buildCheckboxField(field);
      case FormFieldType.radio:
        return _buildRadioField(field);
      case FormFieldType.date:
        return _buildDateField(field);
      case FormField.time:
        return _buildTimeField(field);
      case FormFieldType.file:
        return _buildFileField(field);
      case FormFieldType.switch:
        return _buildSwitchField(field);
      case FormFieldType.slider:
        return _buildSliderField(field);
      case FormFieldType.custom:
        return field.customWidget ?? Container();
    }
  }

  Widget _buildTextField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          keyboardType: field.keyboardType ?? _getKeyboardType(field.type),
          obscureText: field.obscureText,
          maxLength: field.maxLength,
          inputFormatters: field.inputFormatters,
          autofocus: field.autofocus,
          enableInteractiveSelection: field.enableInteractiveSelection,
          readOnly: field.readOnly,
          enabled: widget.enabled && !field.disabled,
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
          validator: (value) => _validateField(field, value),
          onTap: field.onTap,
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNumberField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          obscureText: field.obscureText,
          readOnly: field.readOnly,
          enabled: widget.enabled && !field.disabled,
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
          validator: (value) => _validateField(field, value),
          onTap: field.onTap,
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTextAreaField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          maxLines: field.size == FormFieldSize.large ? 6 : 3,
          maxLength: field.maxLength,
          readOnly: field.readOnly,
          enabled: widget.enabled && !field.disabled,
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
          validator: (value) => _validateField(field, value),
          onTap: field.onTap,
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        DropdownButtonFormField(
          value: _values[field.key]?.toString(),
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          items: field.options?.map((option) => DropdownMenuItem<String>(
            value: option.value,
            child: Row(
              children: [
                if (option.icon != null) option.icon!,
                if (option.icon != null) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      color: option.disabled
                          ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ).toList(),
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
          validator: (value) => _value != null ? null : '${field.label} is required',
          onTap: field.onTap,
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMultiSelectField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        DropdownButtonFormField(
          items: field.options?.map((option) => DropdownMenuItem<String>(
            value: option.value,
            child: CheckboxListTile(
              value: (_values[field.key] as List<String>?)?.contains(option.value) ?? false,
              title: Text(option.label),
              control: Checkbox(
                value: (_values[field.key] as List<String>?)?.contains(option.value) ?? false,
                onChanged: (checked) {
                  final currentValues = (_values[field.key] as List<String>?) ?? [];
                  if (checked) {
                    currentValues.add(option.value);
                  } else {
                    currentValues.remove(option.value);
                  }
                  _updateValue(field.key, currentValues);
                  field.onChanged?.call(currentValues);
                },
              ),
            ),
          )).toList(),
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
          validator: (value) => value != null && value.isNotEmpty ? null : '${field.label} is required',
          onTap: field.onTap,
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCheckboxField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        CheckboxListTile(
          value: _values[field.key] ?? false,
          title: Text(field.label),
          control: Checkbox(
            value: _values[field.key] ?? false,
            onChanged: (value) {
              _updateValue(field.key, value);
              field.onChanged?.call(value);
            },
          ),
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRadioField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        Column(
          children: field.options?.map((option) => RadioListTile(
            title: Text(option.label),
            value: option.value,
            groupValue: _values[field.key]?.toString(),
            onChanged: (value) {
              _updateValue(field.key, value);
              field.onChanged?.call(value);
            },
          )).toList(),
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          keyboardType: TextInputType.datetime,
          readOnly: field.readOnly,
          enabled: widget.enabled && !field.disabled,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: field.controller.text.isNotEmpty
                  ? DateTime.tryParse(field.controller.text)
                  : DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              _controllers[field.key].text = date.toIso8601String().split('T')[0];
              _updateValue(field.key, field.controller.text);
              field.onChanged?.call(field.controller.text);
            }
          },
          validator: (value) => _validateField(field, value),
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTimeField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        TextFormField(
          controller: _controllers[field.key],
          focusNode: _focusNodes[field.key],
          decoration: _buildInputDecoration(field),
          keyboardType: TextInputType.time,
          readOnly: field.readOnly,
          enabled: widget.enabled && !field.disabled,
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: field.controller.text.isNotEmpty
                  ? TimeOfDay.fromHHMM(field.controller.text)
                  : TimeOfDay.now(),
            );
            if (time != null) {
              _controllers[field.key].text = time.format(HHm());
              _updateValue(field.key, field.controller.text);
              field.onChanged?.call(field.controller.text);
            }
          },
          validator: (value) => _validateField(field, value),
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFileField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              Icon(
                Icons.cloud_upload,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  field.placeholder ?? 'Choose file',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              if (field.suffixIcon != null) field.suffixIcon!,
            ],
          ),
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        if (_errors[field.key] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors[field.key]!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSwitchField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field.label,
              style: TextStyle(
                fontSize: _getFontSize(field.size),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Switch(
              value: _values[field.key] ?? false,
              onChanged: (value) {
                _updateValue(field.key, value);
                field.onChanged?.call(value);
              },
            ),
          ],
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSliderField(FormField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (field.label.isNotEmpty)
          Text(
            field.label,
            style: TextStyle(
              fontSize: _getFontSize(field.size),
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        if (field.label.isNotEmpty) const SizedBox(height: 8),
        Slider(
          value: _values[field.key]?.toDouble() ?? 0.0,
          min: field.min ?? 0.0,
          max: field.max ?? 100.0,
          divisions: 20,
          onChanged: (value) {
            _updateValue(field.key, value);
            field.onChanged?.call(value);
          },
        ),
        if (field.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            field.helperText!,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  InputDecoration _buildInputDecoration(FormField field) {
    return InputDecoration(
      hintText: field.placeholder,
      prefixIcon: field.prefixIcon,
      suffixIcon: field.suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _errors[field.key] != null
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      enabled: widget.enabled && !field.disabled,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: _getPadding(field.size),
      ),
      errorText: _errors[field.key],
    );
  }

  TextInputType _getKeyboardType(FormFieldType type) {
    switch (type) {
      case FormFieldType.email:
        return TextInputType.emailAddress;
      case FormFieldType.phone:
        return TextInputType.phone;
      case FormFieldType.url:
        return TextInputType.url;
      case FormFieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  double _getFontSize(FormFieldSize size) {
    switch (size) {
      case FormFieldSize.small:
        return 14;
      case FormFieldSize.medium:
        return 16;
      case FormFieldSize.large:
        return 18;
    }
  }

  double _getPadding(FormFieldSize size) {
    switch (size) {
      case FormFieldSize.small:
        return 12;
      case FormFieldSize.medium:
        return 16;
      case FormFieldSize.large:
        return 20;
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.showCancelButton)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: widget.cancelButton ??
              widget.cancelButton! :
              ElevatedButton(
                onPressed: widget.onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: Text(widget.cancelButtonText),
              ),
          ),
        if (widget.showSubmitButton)
          widget.submitButton ??
            widget.submitButton! :
            ElevatedButton(
              onPressed: widget.isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: widget.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(widget.submitButtonText),
            ),
          ),
      ],
    );
  }
}
