import '../constants/app_constants.dart';

/// QR Code data validation utilities
class QRValidator {
  QRValidator._();

  /// Validates QR code data
  static ValidationResult validate(String data) {
    if (data.isEmpty) {
      return ValidationResult.error('Data cannot be empty');
    }

    if (data.length > AppConstants.maxQRDataLength) {
      return ValidationResult.error(
        'Data exceeds maximum length of ${AppConstants.maxQRDataLength} characters',
      );
    }

    // Check for potentially malicious content
    final security = checkSecurity(data);
    if (!security.isValid) {
      return security;
    }

    return ValidationResult.success();
  }

  /// Checks for security concerns in QR data
  static ValidationResult checkSecurity(String data) {
    // Check for SQL injection patterns
    final sqlInjectionPatterns = [
      r"('|('')|;|--|/\*|\*/|xp_|sp_|exec|execute|select|insert|update|delete|drop|create|alter)",
    ];

    for (final pattern in sqlInjectionPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(data)) {
        return ValidationResult.warning(
          'Potentially dangerous SQL pattern detected',
        );
      }
    }

    // Check for XSS patterns
    final xssPatterns = [
      r'<script[^>]*>.*?</script>',
      r'javascript:',
      r'onerror\s*=',
      r'onload\s*=',
    ];

    for (final pattern in xssPatterns) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(data)) {
        return ValidationResult.warning(
          'Potentially dangerous script pattern detected',
        );
      }
    }

    return ValidationResult.success();
  }

  /// Detects the type of QR code data
  static QRDataType detectType(String data) {
    if (AppConstants.urlPattern.hasMatch(data)) {
      return QRDataType.url;
    } else if (AppConstants.emailPattern.hasMatch(data)) {
      return QRDataType.email;
    } else if (AppConstants.phonePattern.hasMatch(data)) {
      return QRDataType.phone;
    } else if (data.startsWith('WIFI:')) {
      return QRDataType.wifi;
    } else if (data.startsWith('BEGIN:VCARD')) {
      return QRDataType.contact;
    } else if (data.startsWith('BEGIN:VEVENT')) {
      return QRDataType.event;
    } else if (data.startsWith('geo:')) {
      return QRDataType.location;
    } else if (data.startsWith('SMSTO:')) {
      return QRDataType.sms;
    }
    return QRDataType.text;
  }

  /// Validates URL format
  static bool isValidUrl(String url) {
    return AppConstants.urlPattern.hasMatch(url);
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    return AppConstants.emailPattern.hasMatch(email);
  }

  /// Validates phone number format
  static bool isValidPhone(String phone) {
    return AppConstants.phonePattern.hasMatch(phone);
  }
}

/// QR code data type
enum QRDataType {
  text,
  url,
  email,
  phone,
  wifi,
  contact,
  event,
  location,
  sms,
}

/// Validation result
class ValidationResult {
  final bool isValid;
  final String? message;
  final ValidationSeverity severity;

  const ValidationResult._({
    required this.isValid,
    this.message,
    required this.severity,
  });

  factory ValidationResult.success() {
    return const ValidationResult._(
      isValid: true,
      severity: ValidationSeverity.none,
    );
  }

  factory ValidationResult.error(String message) {
    return ValidationResult._(
      isValid: false,
      message: message,
      severity: ValidationSeverity.error,
    );
  }

  factory ValidationResult.warning(String message) {
    return ValidationResult._(
      isValid: true,
      message: message,
      severity: ValidationSeverity.warning,
    );
  }
}

enum ValidationSeverity {
  none,
  warning,
  error,
}
