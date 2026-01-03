class CategoryBreakdown {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final double percentageOfTotal;

  CategoryBreakdown({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentageOfTotal,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentageOfTotal: (json['percentageOfTotal'] as num).toDouble(),
    );
  }
}

class TagBreakdown {
  final String tagId;
  final String tagName;
  final double totalAmount;
  final double percentageOfTotal;

  TagBreakdown({
    required this.tagId,
    required this.tagName,
    required this.totalAmount,
    required this.percentageOfTotal,
  });

  factory TagBreakdown.fromJson(Map<String, dynamic> json) {
    return TagBreakdown(
      tagId: json['tagId'],
      tagName: json['tagName'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentageOfTotal: (json['percentageOfTotal'] as num).toDouble(),
    );
  }
}

class TimeRangeReport {
  final DateTime from;
  final DateTime to;
  final double totalAmount;
  final List<CategoryBreakdown> categoryBreakdown;
  final List<TagBreakdown> tagBreakdown;

  TimeRangeReport({
    required this.from,
    required this.to,
    required this.totalAmount,
    required this.categoryBreakdown,
    required this.tagBreakdown,
  });

  factory TimeRangeReport.fromJson(Map<String, dynamic> json) {
    return TimeRangeReport(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      categoryBreakdown: (json['categoryBreakdown'] as List)
          .map((c) => CategoryBreakdown.fromJson(c))
          .toList(),
      tagBreakdown: (json['tagBreakdown'] as List)
          .map((t) => TagBreakdown.fromJson(t))
          .toList(),
    );
  }
}

class TrendPoint {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalAmount;

  TrendPoint({
    required this.periodStart,
    required this.periodEnd,
    required this.totalAmount,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      periodStart: DateTime.parse(json['periodStart']),
      periodEnd: DateTime.parse(json['periodEnd']),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}

class TrendReport {
  final String granularity;
  final List<TrendPoint> trends;

  TrendReport({
    required this.granularity,
    required this.trends,
  });

  factory TrendReport.fromJson(Map<String, dynamic> json) {
    return TrendReport(
      granularity: json['granularity'],
      trends: (json['trends'] as List)
          .map((t) => TrendPoint.fromJson(t))
          .toList(),
    );
  }
}
