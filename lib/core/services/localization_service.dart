import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalizationService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _localeKey = 'user_locale';
  
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('es', 'ES'), // Spanish
    Locale('fr', 'FR'), // French
    Locale('de', 'DE'), // German
    Locale('it', 'IT'), // Italian
    Locale('pt', 'BR'), // Portuguese (Brazil)
    Locale('ja', 'JP'), // Japanese
    Locale('zh', 'CN'), // Chinese (Simplified)
    Locale('ko', 'KR'), // Korean
    Locale('ar', 'SA'), // Arabic
    Locale('hi', 'IN'), // Hindi
    Locale('ru', 'RU'), // Russian
  ];

  static const Map<String, Map<String, String>> translations = {
    'en_US': {
      'app_name': 'Expense Tracker',
      'expenses': 'Expenses',
      'income': 'Income',
      'categories': 'Categories',
      'budgets': 'Budgets',
      'reports': 'Reports',
      'settings': 'Settings',
      'add_expense': 'Add Expense',
      'add_income': 'Add Income',
      'amount': 'Amount',
      'description': 'Description',
      'date': 'Date',
      'category': 'Category',
      'total_expenses': 'Total Expenses',
      'total_income': 'Total Income',
      'balance': 'Balance',
      'no_data': 'No data available',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'confirm': 'Confirm',
      'are_you_sure': 'Are you sure?',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'offline_mode': 'Offline Mode',
      'sync_pending': 'Sync pending changes',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'create_account': 'Create Account',
      'first_name': 'First Name',
      'last_name': 'Last Name',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'currency': 'Currency',
      'export_data': 'Export Data',
      'import_data': 'Import Data',
      'backup': 'Backup',
      'restore': 'Restore',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'today': 'Today',
      'this_week': 'This Week',
      'this_month': 'This Month',
      'this_year': 'This Year',
      'custom_range': 'Custom Range',
      'recurring': 'Recurring',
      'attachments': 'Attachments',
      'notes': 'Notes',
      'location': 'Location',
      'tags': 'Tags',
      'payment_method': 'Payment Method',
      'analytics': 'Analytics',
      'trends': 'Trends',
      'insights': 'Insights',
      'goals': 'Goals',
      'savings': 'Savings',
      'investments': 'Investments',
      'debts': 'Debts',
      'subscriptions': 'Subscriptions',
      'wishlist': 'Wishlist',
    },
    'es_ES': {
      'app_name': 'Rastreador de Gastos',
      'expenses': 'Gastos',
      'income': 'Ingresos',
      'categories': 'Categorías',
      'budgets': 'Presupuestos',
      'reports': 'Informes',
      'settings': 'Configuración',
      'add_expense': 'Agregar Gasto',
      'add_income': 'Agregar Ingreso',
      'amount': 'Cantidad',
      'description': 'Descripción',
      'date': 'Fecha',
      'category': 'Categoría',
      'total_expenses': 'Total de Gastos',
      'total_income': 'Total de Ingresos',
      'balance': 'Balance',
      'no_data': 'No hay datos disponibles',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'confirm': 'Confirmar',
      'are_you_sure': '¿Estás seguro?',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'offline_mode': 'Modo Sin Conexión',
      'sync_pending': 'Sincronizar cambios pendientes',
      'login': 'Iniciar Sesión',
      'logout': 'Cerrar Sesión',
      'email': 'Correo Electrónico',
      'password': 'Contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'create_account': 'Crear Cuenta',
      'first_name': 'Nombre',
      'last_name': 'Apellido',
      'profile': 'Perfil',
      'notifications': 'Notificaciones',
      'dark_mode': 'Modo Oscuro',
      'language': 'Idioma',
      'currency': 'Moneda',
      'export_data': 'Exportar Datos',
      'import_data': 'Importar Datos',
      'backup': 'Respaldo',
      'restore': 'Restaurar',
      'search': 'Buscar',
      'filter': 'Filtrar',
      'sort': 'Ordenar',
      'today': 'Hoy',
      'this_week': 'Esta Semana',
      'this_month': 'Este Mes',
      'this_year': 'Este Año',
      'custom_range': 'Rango Personalizado',
      'recurring': 'Recurrente',
      'attachments': 'Adjuntos',
      'notes': 'Notas',
      'location': 'Ubicación',
      'tags': 'Etiquetas',
      'payment_method': 'Método de Pago',
      'analytics': 'Análisis',
      'trends': 'Tendencias',
      'insights': 'Perspectivas',
      'goals': 'Metas',
      'savings': 'Ahorros',
      'investments': 'Inversiones',
      'debts': 'Deudas',
      'subscriptions': 'Suscripciones',
      'wishlist': 'Lista de Deseos',
    },
    'fr_FR': {
      'app_name': 'Suivi des Dépenses',
      'expenses': 'Dépenses',
      'income': 'Revenus',
      'categories': 'Catégories',
      'budgets': 'Budgets',
      'reports': 'Rapports',
      'settings': 'Paramètres',
      'add_expense': 'Ajouter une Dépense',
      'add_income': 'Ajouter un Revenu',
      'amount': 'Montant',
      'description': 'Description',
      'date': 'Date',
      'category': 'Catégorie',
      'total_expenses': 'Total des Dépenses',
      'total_income': 'Total des Revenus',
      'balance': 'Solde',
      'no_data': 'Aucune donnée disponible',
      'save': 'Enregistrer',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'confirm': 'Confirmer',
      'are_you_sure': 'Êtes-vous sûr?',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'offline_mode': 'Mode Hors Ligne',
      'sync_pending': 'Synchroniser les modifications en attente',
      'login': 'Connexion',
      'logout': 'Déconnexion',
      'email': 'Email',
      'password': 'Mot de passe',
      'forgot_password': 'Mot de passe oublié?',
      'create_account': 'Créer un Compte',
      'first_name': 'Prénom',
      'last_name': 'Nom',
      'profile': 'Profil',
      'notifications': 'Notifications',
      'dark_mode': 'Mode Sombre',
      'language': 'Langue',
      'currency': 'Devise',
      'export_data': 'Exporter les Données',
      'import_data': 'Importer les Données',
      'backup': 'Sauvegarde',
      'restore': 'Restaurer',
      'search': 'Rechercher',
      'filter': 'Filtrer',
      'sort': 'Trier',
      'today': 'Aujourd\'hui',
      'this_week': 'Cette Semaine',
      'this_month': 'Ce Mois',
      'this_year': 'Cette Année',
      'custom_range': 'Plage Personnalisée',
      'recurring': 'Récurrent',
      'attachments': 'Pièces jointes',
      'notes': 'Notes',
      'location': 'Lieu',
      'tags': 'Étiquettes',
      'payment_method': 'Méthode de Paiement',
      'analytics': 'Analytiques',
      'trends': 'Tendances',
      'insights': 'Aperçus',
      'goals': 'Objectifs',
      'savings': 'Épargne',
      'investments': 'Investissements',
      'debts': 'Dettes',
      'subscriptions': 'Abonnements',
      'wishlist': 'Liste de Souhaits',
    },
    // Add more languages as needed...
  };

  static Future<Locale> getCurrentLocale() async {
    final String? localeCode = await _storage.read(key: _localeKey);
    
    if (localeCode != null) {
      try {
        final parts = localeCode.split('_');
        return Locale(parts[0], parts.length > 1 ? parts[1] : '');
      } catch (e) {
        return const Locale('en', 'US');
      }
    }
    
    return const Locale('en', 'US');
  }

  static Future<void> setLocale(Locale locale) async {
    await _storage.write(
      key: _localeKey,
      value: '${locale.languageCode}_${locale.countryCode ?? ''}',
    );
  }

  static Future<void> setSystemLocale() async {
    await _storage.delete(key: _localeKey);
  }

  static String translate(String key, [Locale? locale]) {
    final effectiveLocale = locale ?? const Locale('en', 'US');
    final localeKey = '${effectiveLocale.languageCode}_${effectiveLocale.countryCode ?? ''}';
    
    final localeTranslations = translations[localeKey] ?? translations['en_US']!;
    
    return localeTranslations[key] ?? key;
  }

  static Locale getLocaleFromCode(String localeCode) {
    final parts = localeCode.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }

  static String getLocaleDisplayName(Locale locale) {
    final displayNames = {
      'en_US': 'English (US)',
      'es_ES': 'Español (España)',
      'fr_FR': 'Français (France)',
      'de_DE': 'Deutsch (Deutschland)',
      'it_IT': 'Italiano (Italia)',
      'pt_BR': 'Português (Brasil)',
      'ja_JP': '日本語 (日本)',
      'zh_CN': '中文 (中国)',
      'ko_KR': '한국어 (한국)',
      'ar_SA': 'العربية (السعودية)',
      'hi_IN': 'हिन्दी (भारत)',
      'ru_RU': 'Русский (Россия)',
    };
    
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    return displayNames[localeKey] ?? localeKey;
  }

  static String getCurrencySymbol(Locale locale) {
    final currencySymbols = {
      'en_US': '\$',
      'es_ES': '€',
      'fr_FR': '€',
      'de_DE': '€',
      'it_IT': '€',
      'pt_BR': 'R\$',
      'ja_JP': '¥',
      'zh_CN': '¥',
      'ko_KR': '₩',
      'ar_SA': 'ر.س',
      'hi_IN': '₹',
      'ru_RU': '₽',
    };
    
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    return currencySymbols[localeKey] ?? '\$';
  }

  static String formatDate(DateTime date, Locale locale) {
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    
    switch (localeKey) {
      case 'en_US':
        return '${date.month}/${date.day}/${date.year}';
      case 'es_ES':
      case 'fr_FR':
      case 'de_DE':
      case 'it_IT':
        return '${date.day}/${date.month}/${date.year}';
      case 'ja_JP':
      case 'ko_KR':
        return '${date.year}/${date.month}/${date.day}';
      case 'zh_CN':
        return '${date.year}年${date.month}月${date.day}日';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  static String formatCurrency(double amount, Locale locale) {
    final symbol = getCurrencySymbol(locale);
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    
    final formattedAmount = amount.toStringAsFixed(2);
    
    switch (localeKey) {
      case 'en_US':
      case 'es_ES':
      case 'pt_BR':
        return '$symbol$formattedAmount';
      case 'fr_FR':
      case 'de_DE':
      case 'it_IT':
        return '$formattedAmount$symbol';
      case 'ja_JP':
      case 'ko_KR':
        return '$symbol$formattedAmount';
      case 'zh_CN':
        return '¥$formattedAmount';
      case 'ar_SA':
        return '$formattedAmount$symbol';
      case 'hi_IN':
        return '₹$formattedAmount';
      case 'ru_RU':
        return '$formattedAmount ₽';
      default:
        return '$symbol$formattedAmount';
    }
  }

  static bool isRTL(Locale locale) {
    final rtlLocales = ['ar_SA', 'he_IL', 'fa_IR'];
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    return rtlLocales.contains(localeKey);
  }

  static Future<void> loadTranslations() async {
    // In a real app, you would load translations from assets or API
    // For now, we're using the hardcoded translations
    print('Translations loaded for ${supportedLocales.length} languages');
  }

  static Map<String, String> getAllTranslations(Locale locale) {
    final localeKey = '${locale.languageCode}_${locale.countryCode ?? ''}';
    return translations[localeKey] ?? translations['en_US']!;
  }

  static Future<void> exportTranslations() async {
    // Export translations to a file for external translation services
    print('Exporting translations for translation service...');
    // Implementation would write to a file
  }

  static Future<void> importTranslations(Map<String, Map<String, String>> newTranslations) async {
    // Import translations from external service
    print('Importing translations from external service...');
    // Implementation would merge new translations
  }
}
