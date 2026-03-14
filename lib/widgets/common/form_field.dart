import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  text,
  email,
  password,
  number,
  phone,
  multiline,
}

class CustomFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final bool required;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int maxLines;
  final int? maxLength;
  final String? counterText;
  final bool showCounter;
  final FieldType fieldType;
  final double? borderRadius;

  const CustomFormField({
    Key? key,
    this.label,
    this.hint,
    this.errorText,
    this.initialValue,
    this.obscureText = false,
    this.enabled = true,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.maxLength,
    this.counterText,
    this.showCounter = false,
    this.fieldType = FieldType.text,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          initialValue: controller == null ? initialValue : null,
          obscureText: obscureText,
          enabled: enabled,
          keyboardType: _getKeyboardType(),
          inputFormatters: _getInputFormatters(),
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: _getInputDecoration(context),
          validator: required ? _validateRequired : null,
        ),
        if (counterText != null || showCounter) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (counterText != null)
                Text(
                  counterText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              if (showCounter && maxLength != null)
                Text(
                  '${maxLength.toString()} characters max',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    const borderColor = Color(0xFFE0E0E0);
    const focusedBorderColor = Color(0xFF4A90E2);

    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: errorColor, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
      ),
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  TextInputType _getKeyboardType() {
    switch (fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.number:
        return TextInputType.number;
      case FieldType.multiline:
        return TextInputType.multiline;
      default:
        return keyboardType;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (fieldType) {
      case FieldType.email:
        return [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ...inputFormatters ?? [],
        ];
      case FieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          ...inputFormatters ?? [],
        ];
      case FieldType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
          ...inputFormatters ?? [],
        ];
      default:
        return inputFormatters;
    }
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    switch (fieldType) {
      case FieldType.email:
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case FieldType.phone:
        if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
    }

    return null;
  }
}
