import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(date);
    }
    return DateFormat.yMd().format(date);
  }

  static String formatDateTime(DateTime date, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(date);
    }
    return DateFormat.yMd().add_jm().format(date);
  }

  static String formatTime(DateTime date, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).format(date);
    }
    return DateFormat.jm().format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inSeconds > 0) {
      return 'Just now';
    } else {
      return 'In the future';
    }
  }

  static String formatCurrency(
    double amount, {
    String currency = 'USD',
    String? locale,
    int decimalDigits = 2,
  }) {
    return NumberFormat.currency(
      locale: locale ?? 'en_US',
      symbol: _getCurrencySymbol(currency),
      decimalDigits: decimalDigits,
    ).format(amount);
  }

  static String formatCompactNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  static DateTime startOfWeek(DateTime date, {int startOfWeek = 1}) {
    // startOfWeek: 1 = Monday, 7 = Sunday
    final day = date.weekday;
    final diff = day - startOfWeek;
    return date.subtract(Duration(days: diff));
  }

  static DateTime endOfWeek(DateTime date, {int startOfWeek = 1}) {
    final start = startOfWeek(date, startOfWeek: startOfWeek);
    return start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1, hours: 23, minutes: 59, seconds: 59));
  }

  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31, 23, 59, 59, 999);
  }

  static List<DateTime> getDaysInMonth(DateTime date) {
    final start = startOfMonth(date);
    final end = endOfMonth(date);
    final days = <DateTime>[];
    
    for (int i = 0; i <= end.day; i++) {
      days.add(DateTime(date.year, date.month, i));
    }
    
    return days;
  }

  static List<DateTime> getWeeksInMonth(DateTime date) {
    final start = startOfMonth(date);
    final end = endOfMonth(date);
    final weeks = <DateTime>[];
    
    DateTime current = startOfWeek(start);
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      weeks.add(current);
      current = current.add(const Duration(days: 7));
    }
    
    return weeks;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isSameWeek(DateTime date1, DateTime date2, {int startOfWeek = 1}) {
    final week1 = startOfWeek(date1, startOfWeek: startOfWeek);
    final week2 = startOfWeek(date2, startOfWeek: startOfWeek);
    return isSameDay(week1, week2);
  }

  static bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  static bool isSameYear(DateTime date1, DateTime date2) {
    return date1.year == date2.year;
  }

  static DateTime addWorkingDays(DateTime date, int days) {
    DateTime result = date;
    int remainingDays = days.abs();
    final direction = days.isNegative ? -1 : 1;

    while (remainingDays > 0) {
      result = result.add(Duration(days: direction));
      if (result.weekday < 5) { // Monday to Friday
        remainingDays--;
      }
    }

    return result;
  }

  static int countWorkingDays(DateTime start, DateTime end) {
    DateTime current = start;
    int workingDays = 0;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (current.weekday < 5) { // Monday to Friday
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }

    return workingDays;
  }

  static List<String> getMonthNames({bool short = false}) {
    return List.generate(12, (index) {
      final date = DateTime(2023, index + 1, 1);
      return short ? DateFormat.M().format(date) : DateFormat.MMMM().format(date);
    });
  }

  static List<String> getWeekdayNames({bool short = false}) {
    return List.generate(7, (index) {
      final date = DateTime(2023, 1, index + 1);
      return short ? DateFormat.E().format(date) : DateFormat.EEEE().format(date);
    });
  }

  static String getMonthName(int month, {bool short = false}) {
    final date = DateTime(2023, month, 1);
    return short ? DateFormat.M().format(date) : DateFormat.MMMM().format(date);
  }

  static String getWeekdayName(int weekday, {bool short = false}) {
    final date = DateTime(2023, 1, weekday);
    return short ? DateFormat.E().format(date) : DateFormat.EEEE().format(date);
  }

  static DateTime parseDate(String dateString, {String? pattern}) {
    if (pattern != null) {
      return DateFormat(pattern).parse(dateString);
    }
    
    // Try common patterns
    final patterns = [
      'yyyy-MM-dd',
      'MM/dd/yyyy',
      'dd/MM/yyyy',
      'yyyy/MM/dd',
      'dd-MM-yyyy',
    ];
    
    for (final p in patterns) {
      try {
        return DateFormat(p).parse(dateString);
      } catch (e) {
        // Continue to next pattern
      }
    }
    
    throw ArgumentError('Could not parse date: $dateString');
  }

  static bool isValidDate(String dateString, {String? pattern}) {
    try {
      parseDate(dateString, pattern: pattern);
      return true;
    } catch (e) {
      return false;
    }
  }

  static int getDaysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    } else {
      return DateTime(year, month + 1, 0).day;
    }
  }

  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static String _getCurrencySymbol(String currency) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'RUB': '₽',
      'BRL': 'R\$',
      'MXN': '\$',
      'ZAR': 'R',
    };
    
    return symbols[currency] ?? currency;
  }
}
