import 'dart:core';

class ValidationUtils {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    // Remove common formatting characters
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Check if it's a valid phone number (10-15 digits, optionally starting with +)
    final phoneRegex = RegExp(r'^\+?\d{10,15}$');
    return phoneRegex.hasMatch(cleanPhone);
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  static bool isValidPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  static bool isValidName(String name) {
    // Only letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s'-]{2,50}$");
    return nameRegex.hasMatch(name);
  }

  static bool isValidAmount(String amount) {
    final amountRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    return amountRegex.hasMatch(amount);
  }

  static bool isValidCardNumber(String cardNumber) {
    // Remove spaces and dashes
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if it's all digits and has correct length (13-19 digits)
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleanCardNumber)) {
      return false;
    }
    
    // Luhn algorithm
    int sum = 0;
    bool isSecondDigit = false;
    
    for (int i = cleanCardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanCardNumber[i]);
      
      if (isSecondDigit) {
        digit *= 2;
        if (digit > 9) {
          digit = digit ~/ 10 + digit % 10;
        }
      }
      
      sum += digit;
      isSecondDigit = !isSecondDigit;
    }
    
    return sum % 10 == 0;
  }

  static bool isValidExpiryDate(String expiryDate) {
    // Format: MM/YY
    final expiryRegex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    if (!expiryRegex.hasMatch(expiryDate)) {
      return false;
    }
    
    final parts = expiryDate.split('/');
    final month = int.parse(parts[0]);
    final year = 2000 + int.parse(parts[1]); // Assume 20xx
    final now = DateTime.now();
    final expiry = DateTime(year, month);
    
    return expiry.isAfter(now);
  }

  static bool isValidCvv(String cvv) {
    final cvvRegex = RegExp(r'^\d{3,4}$');
    return cvvRegex.hasMatch(cvv);
  }

  static bool isValidZipCode(String zipCode, {String? countryCode}) {
    switch (countryCode?.toUpperCase()) {
      case 'US':
        return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode);
      case 'CA':
        return RegExp(r'^[A-Z]\d[A-Z] \d[A-Z]\d$').hasMatch(zipCode);
      case 'UK':
        return RegExp(r'^[A-Z]{1,2}\d[A-Z\d]? \d[A-Z]{2}$').hasMatch(zipCode);
      default:
        return zipCode.isNotEmpty && zipCode.length >= 3;
    }
  }

  static bool isValidUsername(String username) {
    // 3-20 characters, letters, numbers, underscores, hyphens
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');
    return usernameRegex.hasMatch(username);
  }

  static bool isValidStrongPassword(String password) {
    // Enhanced password validation
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'\d'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;
    final hasMaxLength = password.length <= 128;
    
    return hasUpperCase &&
           hasLowerCase &&
           hasDigits &&
           hasSpecialCharacters &&
           hasMinLength &&
           hasMaxLength;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Phone number is required';
    }
    if (!isValidPhone(phone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!password.contains(RegExp(r'\d'))) {
      return 'Password must contain at least one number';
    }
    if (!password.contains(RegExp(r'[@$!%*?&]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateName(String name, {String fieldName = 'Name'}) {
    if (name.isEmpty) {
      return '$fieldName is required';
    }
    if (!isValidName(name)) {
      return 'Please enter a valid $fieldName';
    }
    return null;
  }

  static String? validateAmount(String amount, {String fieldName = 'Amount'}) {
    if (amount.isEmpty) {
      return '$fieldName is required';
    }
    if (!isValidAmount(amount)) {
      return 'Please enter a valid amount';
    }
    final value = double.tryParse(amount);
    if (value == null || value <= 0) {
      return '$fieldName must be greater than 0';
    }
    return null;
  }

  static String? validateRequired(String value, {String fieldName = 'Field'}) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateLength(String value, int minLength, int maxLength, {String fieldName = 'Field'}) {
    if (value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }
    if (value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    return null;
  }

  static String? validateRange(String value, double min, double max, {String fieldName = 'Field'}) {
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  static String? validateCardNumber(String cardNumber) {
    if (cardNumber.isEmpty) {
      return 'Card number is required';
    }
    if (!isValidCardNumber(cardNumber)) {
      return 'Please enter a valid card number';
    }
    return null;
  }

  static String? validateExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty) {
      return 'Expiry date is required';
    }
    if (!isValidExpiryDate(expiryDate)) {
      return 'Please enter a valid expiry date (MM/YY)';
    }
    return null;
  }

  static String? validateCvv(String cvv) {
    if (cvv.isEmpty) {
      return 'CVV is required';
    }
    if (!isValidCvv(cvv)) {
      return 'Please enter a valid CVV';
    }
    return null;
  }

  static String? validateUrl(String url, {String fieldName = 'URL'}) {
    if (url.isEmpty) {
      return '$fieldName is required';
    }
    if (!isValidUrl(url)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (!isValidUsername(username)) {
      return 'Username must be 3-20 characters long and contain only letters, numbers, underscores, and hyphens';
    }
    return null;
  }

  static String? validateZipCode(String zipCode, {String? countryCode}) {
    if (zipCode.isEmpty) {
      return 'Zip code is required';
    }
    if (!isValidZipCode(zipCode, countryCode: countryCode)) {
      return 'Please enter a valid zip code';
    }
    return null;
  }

  static String maskEmail(String email) {
    if (email.isEmpty) return email;
    
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '${username[0]}*@${domain}';
    }
    
    return '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}@$domain';
  }

  static String maskPhone(String phone) {
    if (phone.length < 4) return phone;
    
    return '${phone.substring(0, 3)}${'*' * (phone.length - 3)}';
  }

  static String maskCardNumber(String cardNumber) {
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'[\s-]'), '');
    if (cleanCardNumber.length < 4) return cleanCardNumber;
    
    return '${'*' * (cleanCardNumber.length - 4)}${cleanCardNumber.substring(cleanCardNumber.length - 4)}';
  }

  static String sanitizeInput(String input) {
    // Remove potentially harmful characters
    return input
        .replaceAll(RegExp(r'[<>]'), '')
        .trim();
  }

  static bool containsProfanity(String text) {
    // Simple profanity check - in production, use a proper profanity filter
    final profanityWords = [
      'damn', 'hell', 'shit', 'fuck', 'bitch', 'ass',
      // Add more words as needed
    ];
    
    final lowerText = text.toLowerCase();
    return profanityWords.any((word) => lowerText.contains(word));
  }

  static String generatePassword({int length = 12}) {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const specialChars = '@\$!%*?&';
    
    final allChars = uppercase + lowercase + numbers + specialChars;
    final random = Random();
    
    String password = '';
    
    // Ensure at least one character from each category
    password += uppercase[random.nextInt(uppercase.length)];
    password += lowercase[random.nextInt(lowercase.length)];
    password += numbers[random.nextInt(numbers.length)];
    password += specialChars[random.nextInt(specialChars.length)];
    
    // Fill the rest
    for (int i = 4; i < length; i++) {
      password += allChars[random.nextInt(allChars.length)];
    }
    
    // Shuffle the password
    return String.fromCharCodes(password.split('').map((c) => c.codeUnitAtAt(0))..toList()..shuffle());
  }
}
