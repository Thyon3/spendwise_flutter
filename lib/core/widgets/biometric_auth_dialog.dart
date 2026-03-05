import 'package:flutter/material.dart';

class BiometricAuthDialog extends StatelessWidget {
  const BiometricAuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.fingerprint, size: 32),
          SizedBox(width: 12),
          Text('Biometric Authentication'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Use your fingerprint or face to authenticate',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Icon(
            Icons.fingerprint,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            // Simulate biometric authentication
            await Future.delayed(const Duration(seconds: 1));
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
          child: const Text('Authenticate'),
        ),
      ],
    );
  }

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const BiometricAuthDialog(),
    );
    return result ?? false;
  }
}
