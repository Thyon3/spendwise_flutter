import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getResponsiveValue(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1200) {
      return const EdgeInsets.all(32);
    } else if (width >= 600) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  static int getResponsiveColumns(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1200) {
      return 4;
    } else if (width >= 800) {
      return 3;
    } else if (width >= 600) {
      return 2;
    } else {
      return 1;
    }
  }

  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return getResponsiveValue(context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  static double getResponsiveSpacing(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1200) {
      return 24;
    } else if (width >= 600) {
      return 16;
    } else {
      return 12;
    }
  }

  static int getGridCrossAxisCount(BuildContext context, {
    required double childAspectRatio,
    double spacing = 16,
  }) {
    final width = getWidth(context);
    final padding = getResponsivePadding(context).horizontal;
    final availableWidth = width - padding;
    
    int crossAxisCount = (availableWidth / (childAspectRatio * 100 + spacing)).floor();
    
    // Ensure minimum and maximum counts
    if (crossAxisCount < 1) crossAxisCount = 1;
    if (crossAxisCount > 4) crossAxisCount = 4;
    
    return crossAxisCount;
  }

  static Widget buildResponsiveLayout({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }

  static Widget buildResponsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    double childAspectRatio = 1.0,
    double spacing = 16,
    EdgeInsets? padding,
  }) {
    final crossAxisCount = getGridCrossAxisCount(
      context,
      childAspectRatio: childAspectRatio,
      spacing: spacing,
    );

    return GridView.builder(
      padding: padding ?? getResponsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }

  static Widget buildResponsiveRow({
    required BuildContext context,
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    double spacing = 16,
  }) {
    if (isDesktop(context) || isTablet(context)) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, spacing),
      );
    } else {
      return Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _addSpacing(children, spacing),
      );
    }
  }

  static List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;
    
    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return spacedChildren;
  }

  static double getResponsiveButtonHeight(BuildContext context) {
    return getResponsiveValue(context,
      mobile: 48,
      tablet: 52,
      desktop: 56,
    );
  }

  static double getResponsiveIconSize(BuildContext context) {
    return getResponsiveValue(context,
      mobile: 24,
      tablet: 28,
      desktop: 32,
    );
  }

  static BoxConstraints getResponsiveMaxWidth(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1200) {
      return const BoxConstraints(maxWidth: 1200);
    } else if (width >= 600) {
      return const BoxConstraints(maxWidth: 800);
    } else {
      return const BoxConstraints(maxWidth: 600);
    }
  }
}
