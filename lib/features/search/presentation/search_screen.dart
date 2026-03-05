import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search expenses, categories...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? _buildRecentSearches()
          : _buildSearchResults(),
    );
  }

  Widget _buildRecentSearches() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Recent Searches',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _buildRecentSearchItem('Groceries'),
        _buildRecentSearchItem('Restaurant'),
        _buildRecentSearchItem('Gas'),
        const SizedBox(height: 24),
        Text(
          'Popular Categories',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(label: const Text('Food')),
            Chip(label: const Text('Transport')),
            Chip(label: const Text('Shopping')),
            Chip(label: const Text('Entertainment')),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentSearchItem(String query) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(query),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 20),
        onPressed: () {
          // Remove from recent searches
        },
      ),
      onTap: () {
        _searchController.text = query;
        setState(() {
          _searchQuery = query;
        });
      },
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Results for "$_searchQuery"',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildResultCard(
          title: 'Grocery Shopping',
          category: 'Food',
          amount: 85.50,
          date: 'Today',
        ),
        _buildResultCard(
          title: 'Gas Station',
          category: 'Transport',
          amount: 45.00,
          date: 'Yesterday',
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required String title,
    required String category,
    required double amount,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text('$category • $date'),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
