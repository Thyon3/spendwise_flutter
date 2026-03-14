import 'package:flutter/material.dart';

enum DialogType {
  basic,
  alert,
  confirm,
  info,
  success,
  warning,
  error,
}

enum DialogSize {
  small,
  medium,
  large,
  full,
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? customContent;
  final List<Widget>? actions;
  final DialogType type;
  final DialogSize size;
  final bool barrierDismissible;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onDismiss;
  final bool showCloseButton;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    Key? key,
    required this.title,
    this.content,
    this.customContent,
    this.actions,
    this.type = DialogType.basic,
    this.size = DialogSize.medium,
    this.barrierDismissible = true,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.onDismiss,
    this.showCloseButton = false,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogColor = backgroundColor ?? _getBackgroundColor(theme);
    final dialogRadius = borderRadius ?? _getBorderRadius();
    final dialogPadding = padding ?? _getPadding();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: _getConstraints(),
        child: Container(
          decoration: BoxDecoration(
            color: dialogColor,
            borderRadius: BorderRadius.circular(dialogRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: dialogPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 16),
                _buildContent(),
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildActions(theme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: iconColor ?? _getIconColor(theme),
            size: 24,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (showCloseButton)
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    if (customContent != null) {
      return customContent!;
    }

    if (content != null) {
      return Text(
        content!,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          height: 1.5,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActions(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions!,
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (type) {
      case DialogType.basic:
        return theme.colorScheme.surface;
      case DialogType.alert:
        return theme.colorScheme.errorContainer;
      case DialogType.confirm:
        return theme.colorScheme.primaryContainer;
      case DialogType.info:
        return theme.colorScheme.tertiaryContainer;
      case DialogType.success:
        return Colors.green.withOpacity(0.1);
      case DialogType.warning:
        return Colors.orange.withOpacity(0.1);
      case DialogType.error:
        return theme.colorScheme.errorContainer;
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (type) {
      case DialogType.basic:
        return theme.colorScheme.primary;
      case DialogType.alert:
        return theme.colorScheme.error;
      case DialogType.confirm:
        return theme.colorScheme.primary;
      case DialogType.info:
        return theme.colorScheme.tertiary;
      case DialogType.success:
        return Colors.green;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.error:
        return theme.colorScheme.error;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case DialogSize.small:
        return 8;
      case DialogSize.medium:
        return 12;
      case DialogSize.large:
        return 16;
      case DialogSize.full:
        return 0;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case DialogSize.small:
        return const EdgeInsets.all(16);
      case DialogSize.medium:
        return const EdgeInsets.all(24);
      case DialogSize.large:
        return const EdgeInsets.all(32);
      case DialogSize.full:
        return const EdgeInsets.all(24);
    }
  }

  BoxConstraints _getConstraints() {
    switch (size) {
      case DialogSize.small:
        return const BoxConstraints(maxWidth: 300, minHeight: 100);
      case DialogSize.medium:
        return const BoxConstraints(maxWidth: 500, minHeight: 200);
      case DialogSize.large:
        return const BoxConstraints(maxWidth: 800, minHeight: 300);
      case DialogSize.full:
        return const BoxConstraints(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          minHeight: 400,
        );
    }
  }

  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? confirmText,
    String? cancelText,
    DialogType type = DialogType.confirm,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: type,
        icon: type == DialogType.confirm ? Icons.help_outline : 
              type == DialogType.alert ? Icons.warning : Icons.info,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(cancelText ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
      ),
    );
  }

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? buttonText,
    DialogType type = DialogType.alert,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: type,
        icon: type == DialogType.error ? Icons.error :
              type == DialogType.warning ? Icons.warning :
              type == DialogType.success ? Icons.check_circle : Icons.info,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? hintText,
    String? initialValue,
    TextInputType? keyboardType,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (content != null) ...[
              Text(content!),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelText ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
              onConfirm?.call();
            },
            child: Text(confirmText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showLoadingDialog({
    required BuildContext context,
    String title = 'Loading...',
    String? content,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: DialogType.info,
        customContent: const Center(
          child: CircularProgressIndicator(),
        ),
        actions: const [],
      ),
    );
  }

  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? buttonText,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: DialogType.success,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? buttonText,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: DialogType.error,
        icon: Icons.error,
        iconColor: Theme.of(context).colorScheme.error,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showInfoDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? buttonText,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: DialogType.info,
        icon: Icons.info,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> showWarningDialog({
    required BuildContext context,
    required String title,
    String? content,
    String? buttonText,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomDialog(
        title: title,
        content: content,
        type: DialogType.warning,
        icon: Icons.warning,
        iconColor: Colors.orange,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }
}

class BottomSheetDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool isScrollable;
  final double? height;
  final EdgeInsets? padding;

  const BottomSheetDialog({
    Key? key,
    required this.title,
    required this.child,
    this.actions,
    this.isScrollable = true,
    this.height,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sheetPadding = padding ?? const EdgeInsets.all(16);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: sheetPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: sheetPadding,
              child: isScrollable
                  ? SingleChildScrollView(child: child)
                  : child,
            ),
          ),
          
          // Actions
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: sheetPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }

  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    List<Widget>? actions,
    bool isScrollable = true,
    double? height,
    EdgeInsets? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetDialog(
        title: title,
        child: child,
        actions: actions,
        isScrollable: isScrollable,
        height: height,
        padding: padding,
      ),
    );
  }
}
