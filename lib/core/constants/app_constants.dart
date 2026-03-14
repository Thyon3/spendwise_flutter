class AppConstants {
  // API
  static const String apiBaseUrl = 'http://localhost:3000';
  static const int apiTimeout = 30000; // milliseconds
  static const String apiVersion = 'v1';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyCurrency = 'currency';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyPreferences = 'user_preferences';
  static const String keyLanguage = 'language';
  static const String keyTimezone = 'timezone';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxDescriptionLength = 500;
  static const int maxTitleLength = 100;
  static const int maxNoteLength = 1000;

  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Time formats
  static const String timeFormat12 = 'hh:mm a';
  static const String timeFormat24 = 'HH:mm';

  // Currencies
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'INR', 'AUD', 'CAD', 'CHF',
    'CNY', 'SEK', 'NOK', 'DKK', 'PLN', 'RUB', 'BRL', 'MXN',
    'ZAR', 'SGD', 'HKD', 'NZD', 'KRW', 'TRY', 'THB', 'IDR',
    'MYR', 'PHP', 'VND', 'EGP', 'SAR', 'AED', 'ILS', 'CLP',
    'COP', 'PEN', 'UYU', 'ARS', 'BOB', 'PYG', 'GYD', 'TTD',
    'JMD', 'BBD', 'BZD', 'NIO', 'CRC', 'HNL', 'GTQ', 'PAB',
    'DOP', 'CUP', 'XCD', 'BMD', 'KYD', 'SVC', 'AWG', 'ANG',
    'CUC', 'XOF', 'XAF', 'XPF', 'GHS', 'NGN', 'ZMW', 'BWP',
    'SZL', 'LSL', 'NAD', 'MZN', 'AOA', 'CVE', 'GWP', 'SCR',
    'MUR', 'MVR', 'LKR', 'PKR', 'AFN', 'ALL', 'AMD', 'AZN',
    'BHD', 'BDT', 'BND', 'BTN', 'BRL', 'BWP', 'BYN', 'BZD',
    'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP',
    'CZK', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR',
    'FJD', 'FKP', 'GBP', 'GEL', 'GGP', 'GHS', 'GIP', 'GMD',
    'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF',
    'IDR', 'ILS', 'IMP', 'INR', 'IQD', 'IRR', 'ISK', 'JEP',
    'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KPW',
    'KRW', 'KWD', 'KYD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD',
    'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT',
    'MOP', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN',
    'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB',
    'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON',
    'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK',
    'SGD', 'SHP', 'SLL', 'SOS', 'SRD', 'SSP', 'STN', 'SVC',
    'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY',
    'TTD', 'TVD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU',
    'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XOF',
    'XPF', 'YER', 'ZAR', 'ZMW', 'ZWL',
  ];

  // Categories
  static const int maxCategories = 50;
  static const int maxTags = 100;
  static const int maxCategoryNameLength = 50;
  static const int maxTagNameLength = 30;

  // File upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/jpg',
    'image/gif',
    'image/webp',
    'image/svg+xml',
  ];
  static const List<String> allowedDocumentTypes = [
    'application/pdf',
    'text/plain',
    'text/csv',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ];
  static const List<String> allowedFileTypes = [
    ...allowedImageTypes,
    ...allowedDocumentTypes,
  ];

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double xsSpacing = 4.0;
  static const double smSpacing = 8.0;
  static const double mdSpacing = 16.0;
  static const double lgSpacing = 24.0;
  static const double xlSpacing = 32.0;
  static const double xxlSpacing = 48.0;

  // Border radius
  static const double smallRadius = 4.0;
  static const double mediumRadius = 8.0;
  static const double largeRadius = 12.0;
  static const double extraLargeRadius = 16.0;

  // Font sizes
  static const double xsFontSize = 12.0;
  static const double smFontSize = 14.0;
  static const double mdFontSize = 16.0;
  static const double lgFontSize = 18.0;
  static const double xlFontSize = 20.0;
  static const double xxlFontSize = 24.0;
  static const double xxxlFontSize = 32.0;

  // Icon sizes
  static const double smallIcon = 16.0;
  static const double mediumIcon = 24.0;
  static const double largeIcon = 32.0;
  static const double extraLargeIcon = 48.0;

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // Cache durations
  static const Duration shortCache = Duration(minutes: 5);
  static const Duration mediumCache = Duration(hours: 1);
  static const Duration longCache = Duration(hours: 24);

  // Error messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String forbiddenError = 'Access denied.';
  static const String notFoundError = 'Resource not found.';
  static const String validationError = 'Invalid input data.';
  static const String unknownError = 'An unexpected error occurred.';

  // Success messages
  static const String saveSuccess = 'Data saved successfully.';
  static const String deleteSuccess = 'Data deleted successfully.';
  static const String updateSuccess = 'Data updated successfully.';
  static const String createSuccess = 'Data created successfully.';

  // App info
  static const String appName = 'Expense Tracker';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableNotifications = true;
  static const bool enableOfflineMode = false;
  static const bool enableDarkMode = true;
  static const bool enableBiometric = true;
  static const bool enableCloudSync = true;

  // Rate limiting
  static const int maxApiCallsPerMinute = 60;
  static const int maxUploadsPerHour = 10;
  static const int maxExportsPerDay = 5;

  // Security
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 24);

  // Localization
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'zh': '中文',
    'ko': '한국어',
    'ar': 'العربية',
    'hi': 'हिन्दी',
    'bn': 'বাংলা',
    'pa': 'ਪੰਜਾਬੀ',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'mr': 'मराठी',
    'gu': 'ગુજરાતી',
    'kn': 'ಕನ್ನಡ',
    'ml': 'മലയാളം',
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'tr': 'Türkçe',
    'pl': 'Polski',
    'nl': 'Nederlands',
    'sv': 'Svenska',
    'no': 'Norsk',
    'da': 'Dansk',
    'fi': 'Suomi',
    'el': 'Ελληνικά',
    'he': 'עברית',
    'cs': 'Čeština',
    'sk': 'Slovenčina',
    'hu': 'Magyar',
    'ro': 'Română',
    'bg': 'Български',
    'hr': 'Hrvatski',
    'sr': 'Српски',
    'sl': 'Slovenščina',
    'et': 'Eesti',
    'lv': 'Latviešu',
    'lt': 'Lietuvių',
    'uk': 'Українська',
    'be': 'Беларуская',
    'ka': 'ქართული',
    'hy': 'Հայեեան',
    'az': 'Azərbaycan',
    'kk': 'Қазақша',
    'ky': 'Кыргызча',
    'uz': 'O'zbek',
    'tg': 'Тоҷикӣ',
    'mn': 'Монгол',
    'ne': 'नेपाली',
    'si': 'සිංහ',
    'my': 'မြနမ်',
    'km': 'ខ្មែរ',
    'lo': 'ລາວ',
    'kh': 'ខ្មែរ',
    'gl': 'Galego',
    'eu': 'Euskara',
    'ca': 'Català',
    'is': 'Íslenska',
    'mt': 'Malti',
    'cy': 'Cymraeg',
    'ga': 'Gaeilge',
    'gd': 'Gàidhlig',
    'cy': 'Cymraeg',
  };

  // Theme colors
  static const Map<String, String> themeColors = {
    'primary': '#1976D2',
    'secondary': '#424242',
    'accent': '#FF4081',
    'success': '#4CAF50',
    'warning': '#FF9800',
    'error': '#F44336',
    'info': '#2196F3',
    'background': '#FFFFFF',
    'surface': '#F5F5F5',
    'onPrimary': '#FFFFFF',
    'onSecondary': '#FFFFFF',
    'onSurface': '#000000',
    'onBackground': '#000000',
  };

  // App URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@example.com';
  static const String supportPhone = '+1-800-123-4567';

  // Social media
  static const Map<String, String> socialMediaUrls = {
    'facebook': 'https://facebook.com/expensetracker',
    'twitter': 'https://twitter.com/expensetracker',
    'instagram': 'https://instagram.com/expensetracker',
    'linkedin': 'https://linkedin.com/company/expensetracker',
    'youtube': 'https://youtube.com/expensetracker',
  };

  // Development
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableCrashReporting = true;
  static const bool enableAnalytics = true;
}
