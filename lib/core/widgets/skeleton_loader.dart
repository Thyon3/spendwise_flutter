import 'package:flutter/material.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          const SkeletonLoader(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(24))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16, borderRadius: BorderRadius.circular(4)),
                const SizedBox(height: 8),
                SkeletonLoader(width: 150, height: 12, borderRadius: BorderRadius.circular(4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(width: double.infinity, height: 20, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 12),
            SkeletonLoader(width: 200, height: 16, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 8),
            SkeletonLoader(width: 150, height: 16, borderRadius: BorderRadius.circular(4)),
          ],
        ),
      ),
    );
  }
}
