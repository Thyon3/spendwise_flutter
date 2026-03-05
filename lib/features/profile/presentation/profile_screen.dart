import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Account',
            items: [
              _buildListItem(
                context,
                icon: Icons.person_outline,
                title: 'Personal Information',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.security,
                title: 'Security',
                subtitle: '2FA Enabled',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.devices,
                title: 'Active Sessions',
                subtitle: '3 devices',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Preferences',
            items: [
              _buildListItem(
                context,
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.attach_money,
                title: 'Currency',
                subtitle: 'USD',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Data',
            items: [
              _buildListItem(
                context,
                icon: Icons.backup,
                title: 'Backup & Restore',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.download,
                title: 'Export Data',
                onTap: () {},
              ),
              _buildListItem(
                context,
                icon: Icons.delete_outline,
                title: 'Delete Account',
                titleColor: Colors.red,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () {
              // Logout
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ),
        Card(
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: titleColor != null ? TextStyle(color: titleColor) : null,
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
