import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final int rating;
  final int maxRating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final Function(int)? onRatingChanged;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 24,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final isActive = index < rating;
        return GestureDetector(
          onTap: onRatingChanged != null
              ? () => onRatingChanged!(index + 1)
              : null,
          child: Icon(
            isActive ? Icons.star : Icons.star_border,
            color: isActive ? activeColor : inactiveColor,
            size: size,
          ),
        );
      }),
    );
  }
}
