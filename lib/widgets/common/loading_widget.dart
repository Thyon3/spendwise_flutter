import 'package:flutter/material.dart';

enum LoadingType {
  spinner,
  dots,
  bars,
  pulse,
}

enum LoadingSize {
  small,
  medium,
  large,
}

class CustomLoadingWidget extends StatelessWidget {
  final LoadingType type;
  final LoadingSize size;
  final Color? color;
  final String? message;
  final double? width;
  final double? height;

  const CustomLoadingWidget({
    Key? key,
    this.type = LoadingType.spinner,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingColor = color ?? theme.colorScheme.primary;
    final loadingSize = _getSize();
    final loadingWidget = _buildLoadingWidget(loadingColor, loadingSize);

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingWidget,
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    }

    return loadingWidget;
  }

  Widget _buildLoadingWidget(Color color, double size) {
    switch (type) {
      case LoadingType.spinner:
        return SizedBox(
          width: width ?? size,
          height: height ?? size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
      case LoadingType.dots:
        return SizedBox(
          width: width ?? size * 3,
          height: height ?? size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 100)),
                width: size / 4,
                height: size / 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      case LoadingType.bars:
        return SizedBox(
          width: width ?? size * 2,
          height: height ?? size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(4, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200 + (index * 50)),
                width: size / 8,
                height: size * (0.3 + (index * 0.2)),
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      case LoadingType.pulse:
        return SizedBox(
          width: width ?? size,
          height: height ?? size,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                width: size * 0.6,
                height: size * 0.6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
    }
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 48;
      case LoadingSize.large:
        return 72;
    }
  }
}

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final LoadingType loadingType;
  final LoadingSize loadingSize;
  final Color? loadingColor;
  final String? loadingMessage;
  final Color? overlayColor;

  const LoadingOverlay({
    Key? key,
    required this.child,
    required this.isLoading,
    this.loadingType = LoadingType.spinner,
    this.loadingSize = LoadingSize.medium,
    this.loadingColor,
    this.loadingMessage,
    this.overlayColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.3),
            child: Center(
              child: CustomLoadingWidget(
                type: loadingType,
                size: loadingSize,
                color: loadingColor ?? Colors.white,
                message: loadingMessage,
              ),
            ),
          ),
      ],
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const SkeletonLoader({
    Key? key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    final theme = Theme.of(context);
    final skeletonBaseColor = baseColor ?? theme.colorScheme.surface;
    final skeletonHighlightColor = highlightColor ?? theme.colorScheme.onSurface.withOpacity(0.1);

    return AnimatedContainer(
      duration: duration,
      decoration: BoxDecoration(
        color: skeletonBaseColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: skeletonHighlightColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    skeletonHighlightColor,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressLoader extends StatelessWidget {
  final double progress;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;
  final String? label;
  final bool showPercentage;

  const ProgressLoader({
    Key? key,
    required this.progress,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius,
    this.label,
    this.showPercentage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor = color ?? theme.colorScheme.primary;
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ),
      ],
    );
  }
}
