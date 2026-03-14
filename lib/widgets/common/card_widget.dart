import 'package:flutter/material.dart';

enum CardType {
  basic,
  elevated,
  outlined,
  filled,
}

enum CardSize {
  small,
  medium,
  large,
  auto,
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final CardType type;
  final CardSize size;
  final Color? color;
  final Color? shadowColor;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final bool isClickable;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;

  const CustomCard({
    Key? key,
    required this.child,
    this.type = CardType.basic,
    this.size = CardSize.medium,
    this.color,
    this.shadowColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.isClickable = false,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.surface;
    final cardElevation = elevation ?? _getElevation();
    final cardBorderRadius = borderRadius ?? _getBorderRadius();
    final cardPadding = padding ?? _getPadding();
    final cardMargin = margin ?? _getMargin();

    Widget cardWidget = Container(
      margin: cardMargin,
      decoration: _getDecoration(theme, cardColor, cardBorderRadius),
      child: Padding(
        padding: cardPadding,
        child: child,
      ),
    );

    if (isClickable || onTap != null) {
      cardWidget = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          child: cardWidget,
        ),
      );
    }

    if (size != CardSize.auto) {
      cardWidget = ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: _getMinHeight(),
          maxHeight: _getMaxHeight(),
        ),
        child: cardWidget,
      );
    }

    return cardWidget;
  }

  BoxDecoration _getDecoration(ThemeData theme, Color cardColor, double cardBorderRadius) {
    switch (type) {
      case CardType.basic:
        return BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        );
      case CardType.elevated:
        return BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case CardType.outlined:
        return BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outline,
            width: borderWidth ?? 1,
          ),
        );
      case CardType.filled:
        return BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
    }
  }

  double _getElevation() {
    switch (type) {
      case CardType.basic:
        return 0;
      case CardType.elevated:
        return 4;
      case CardType.outlined:
        return 0;
      case CardType.filled:
        return 2;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case CardSize.small:
        return 8;
      case CardSize.medium:
        return 12;
      case CardSize.large:
        return 16;
      case CardSize.auto:
        return 12;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(12);
      case CardSize.medium:
        return const EdgeInsets.all(16);
      case CardSize.large:
        return const EdgeInsets.all(20);
      case CardSize.auto:
        return const EdgeInsets.all(16);
    }
  }

  EdgeInsets _getMargin() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(4);
      case CardSize.medium:
        return const EdgeInsets.all(8);
      case CardSize.large:
        return const EdgeInsets.all(12);
      case CardSize.auto:
        return const EdgeInsets.all(8);
    }
  }

  double _getMinHeight() {
    switch (size) {
      case CardSize.small:
        return 60;
      case CardSize.medium:
        return 100;
      case CardSize.large:
        return 140;
      case CardSize.auto:
        return 0;
    }
  }

  double _getMaxHeight() {
    switch (size) {
      case CardSize.small:
        return 120;
      case CardSize.medium:
        return 200;
      case CardSize.large:
        return 300;
      case CardSize.auto:
        return double.infinity;
    }
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showTrend;
  final bool isPositiveTrend;
  final double? trendPercentage;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.backgroundColor,
    this.onTap,
    this.showTrend = false,
    this.isPositiveTrend = true,
    this.trendPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return CustomCard(
      type: CardType.elevated,
      size: CardSize.medium,
      color: bgColor,
      onTap: onTap,
      isClickable: onTap != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (showTrend && trendPercentage != null)
                      Row(
                        children: [
                          Icon(
                            isPositiveTrend ? Icons.trending_up : Icons.trending_down,
                            size: 16,
                            color: isPositiveTrend ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${trendPercentage!.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: isPositiveTrend ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? action;

  const InfoCard({
    Key? key,
    required this.title,
    required this.description,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final txtColor = textColor ?? theme.colorScheme.onSurface;

    return CustomCard(
      type: CardType.outlined,
      size: CardSize.medium,
      color: bgColor,
      onTap: onTap,
      isClickable: onTap != null,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: txtColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: txtColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class MediaCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget> actions;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MediaCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.actions = const [],
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      type: CardType.elevated,
      size: CardSize.medium,
      color: backgroundColor,
      onTap: onTap,
      isClickable: onTap != null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}
