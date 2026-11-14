import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const FilterBottomSheet({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<String> categories = [
    'Semua',
    'AI',
    'Mobile',
    'IoT',
    'Cybersecurity',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Kategori',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RadioGroup<String>(
              groupValue: selectedCategory,
              onChanged: (value) {
                if (value != null) {
                  onCategorySelected(value);
                  Navigator.pop(context);
                }
              },
              child: Column(
                children: categories.map((category) {
                  return RadioListTile<String>(
                    title: Text(category),
                    value: category,
                    activeColor: Colors.deepPurple,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
