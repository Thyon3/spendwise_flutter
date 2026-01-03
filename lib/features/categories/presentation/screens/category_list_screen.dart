import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/category_notifier.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColor(category.color),
              ),
              title: Text(category.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => ref.read(categoryListProvider.notifier).deleteCategory(category.id),
              ),
              onTap: () => _showAddEditDialog(context, ref, category: category),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getColor(String hex) {
    try {
      return Color(int.parse(hex.replaceAll('#', '0xff')));
    } catch (_) {
      return Colors.blue;
    }
  }

  void _showAddEditDialog(BuildContext context, WidgetRef ref, {dynamic category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final colorController = TextEditingController(text: category?.color ?? '#4287f5');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category == null ? 'Add Category' : 'Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Color (Hex)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (category == null) {
                ref.read(categoryListProvider.notifier).addCategory(nameController.text, colorController.text);
              } else {
                ref.read(categoryListProvider.notifier).updateCategory(category.id, nameController.text, colorController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
