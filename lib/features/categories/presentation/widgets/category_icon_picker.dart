import 'package:flutter/material.dart';

class CategoryIconPicker extends StatelessWidget {
  final IconData? selectedIcon;
  final ValueChanged<IconData> onIconSelected;

  const CategoryIconPicker({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
  });

  static const List<IconData> availableIcons = [
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.local_gas_station,
    Icons.home,
    Icons.directions_car,
    Icons.flight,
    Icons.movie,
    Icons.sports_esports,
    Icons.fitness_center,
    Icons.medical_services,
    Icons.school,
    Icons.work,
    Icons.pets,
    Icons.child_care,
    Icons.shopping_bag,
    Icons.phone,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: availableIcons.length,
      itemBuilder: (context, index) {
        final icon = availableIcons[index];
        final isSelected = icon == selectedIcon;

        return InkWell(
          onTap: () => onIconSelected(icon),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : null,
            ),
            child: Icon(
              icon,
              size: 32,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
            ),
          ),
        );
      },
    );
  }
}
