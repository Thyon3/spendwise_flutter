import 'package:flutter/material.dart';

enum NavigationType {
  bottom,
  rail,
  persistent,
}

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;
  final NavigationType type;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? iconSize;
  final bool showLabels;
  final bool enableAnimation;
  final Duration animationDuration;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.type = NavigationType.bottom,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.iconSize,
    this.showLabels = true,
    this.enableAnimation = true,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NavigationType.bottom:
        return _buildBottomNavigation(context);
      case NavigationType.rail:
        return _buildNavigationRail(context);
      case NavigationType.persistent:
        return _buildPersistentBottomSheet(context);
    }
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return _buildNavigationItem(
                context,
                item,
                isSelected,
                index,
                isHorizontal: true,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildNavigationItem(
                      context,
                      item,
                      isSelected,
                      index,
                      isHorizontal: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPersistentBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Navigation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              
              // Navigation items
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = index == currentIndex;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: _buildNavigationItem(
                        context,
                        item,
                        isSelected,
                        index,
                        isHorizontal: true,
                        isExpanded: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
    int index,
    {
      required bool isHorizontal,
      bool isExpanded = false,
    }) {
    final theme = Theme.of(context);
    final selectedColor = selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6);
    final itemColor = isSelected ? selectedColor : unselectedColor;
    
    Widget content;
    
    if (isExpanded) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: selectedColor.withOpacity(0.3)) : null,
        ),
        child: Row(
          children: [
            _buildIcon(item, itemColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: itemColor,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: itemColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.badge != null)
              _buildBadge(item.badge!),
          ],
        ),
      );
    } else {
      content = GestureDetector(
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: enableAnimation ? animationDuration : Duration.zero,
          padding: EdgeInsets.symmetric(
            horizontal: isHorizontal ? 12 : 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(item, itemColor),
              if (showLabels && isHorizontal) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: itemColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (!isExpanded) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: content,
      );
    }

    return content;
  }

  Widget _buildIcon(NavigationItem item, Color color) {
    final iconSize = this.iconSize ?? 24;
    
    if (item.icon != null) {
      return Icon(
        item.icon,
        size: iconSize,
        color: color,
      );
    }
    
    if (item.customIcon != null) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: item.customIcon,
      );
    }
    
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(iconSize / 2),
      ),
      child: Center(
        child: Text(
          item.label[0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: iconSize / 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        badge,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? customIcon;
  final String? badge;
  final bool isActive;

  const NavigationItem({
    required this.label,
    this.subtitle,
    this.icon,
    this.customIcon,
    this.badge,
    this.isActive = false,
  });
}

class AdaptiveBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AdaptiveBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use navigation rail for larger screens
    if (screenWidth >= 1200) {
      return CustomBottomNavigation(
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
        type: NavigationType.rail,
        backgroundColor: backgroundColor,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        showLabels: false,
      );
    }
    
    // Use bottom navigation for smaller screens
    return CustomBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: NavigationType.bottom,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
    );
  }
}

class FloatingBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavigationItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? height;
  final double? borderRadius;

  const FloatingBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 80,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;
              
              return _buildFloatingItem(context, item, isSelected, index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingItem(
    BuildContext context,
    NavigationItem item,
    bool isSelected,
    int index,
  ) {
    final theme = Theme.of(context);
    final selectedColor = selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6);
    final itemColor = isSelected ? selectedColor : unselectedColor;
    
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: itemColor,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<Tab> tabs;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final Color? labelColor;
  final bool isScrollable;

  const TabBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
    this.backgroundColor,
    this.indicatorColor,
    this.labelColor,
    this.isScrollable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: TabBar(
        controller: TabController(
          length: tabs.length,
          vsync: Navigator.of(context),
          initialIndex: currentIndex,
        ),
        onTap: onTap,
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? Theme.of(context).colorScheme.primary,
        labelColor: labelColor ?? Theme.of(context).colorScheme.primary,
        unselectedLabelColor: labelColor ?? Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        tabs: tabs,
      ),
    );
  }
}
