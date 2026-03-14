import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  text,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final Widget? icon;
  final Color? color;
  final double? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.icon,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(theme);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: _buildChild(),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: _getTextColor(),
              fontWeight: _getFontWeight(),
              fontSize: _getFontSize(),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: _getTextColor(),
        fontWeight: _getFontWeight(),
        fontSize: _getFontSize(),
      ),
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.colorScheme.secondary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        );
      case ButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: color ?? theme.colorScheme.primary,
          side: BorderSide(color: color ?? theme.colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        );
      case ButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: color ?? theme.colorScheme.primary,
        );
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.outline:
      case ButtonType.text:
        return color ?? Colors.blue;
    }
  }

  FontWeight _getFontWeight() {
    switch (size) {
      case ButtonSize.small:
        return FontWeight.w500;
      case ButtonSize.medium:
        return FontWeight.w600;
      case ButtonSize.large:
        return FontWeight.w700;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 12;
      case ButtonSize.medium:
        return 14;
      case ButtonSize.large:
        return 16;
    }
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }
}
