import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsState.when(
        data: (settings) => ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Preferred Currency'),
              subtitle: Text(settings.preferredCurrency),
              onTap: () {
                // TODO: Show currency picker dialog
                _showCurrencyPicker(context, ref, settings.preferredCurrency);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Theme'),
              subtitle: Text(settings.theme),
              onTap: () {
                _showThemePicker(context, ref, settings.theme);
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              value: settings.notificationsEnabled,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).toggleNotifications(value);
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Currency'),
        children: ['USD', 'EUR', 'GBP', 'JPY'].map((c) => SimpleDialogOption(
          onPressed: () {
            ref.read(settingsProvider.notifier).updateCurrency(c);
            Navigator.pop(context);
          },
          child: Text(c, style: TextStyle(fontWeight: c == current ? FontWeight.bold : FontWeight.normal)),
        )).toList(),
      ),
    );
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Theme'),
        children: ['SYSTEM', 'LIGHT', 'DARK'].map((c) => SimpleDialogOption(
          onPressed: () {
            ref.read(settingsProvider.notifier).updateTheme(c);
            Navigator.pop(context);
          },
          child: Text(c, style: TextStyle(fontWeight: c == current ? FontWeight.bold : FontWeight.normal)),
        )).toList(),
      ),
    );
  }
}
