/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'QR Code Pro';
  static const String appVersion = '2.0.0';

  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String historyBoxName = 'qr_history';
  static const String settingsBoxName = 'app_settings';

  // QR Code Settings
  static const int maxHistoryItems = 1000;
  static const int qrCodeSize = 512;
  static const int defaultQRDisplaySize = 300;
  static const double qrCodePadding = 16.0;

  // Security
  static const int maxQRDataLength = 4296; // QR Code max capacity
  static const int maxURLLength = 2048;

  // Timeouts
  static const Duration scannerTimeout = Duration(seconds: 30);
  static const Duration apiTimeout = Duration(seconds: 10);

  // File names
  static const String exportedQRPrefix = 'qrcode_';
  static const String exportedPDFPrefix = 'qrcodes_';

  // Analytics
  static const String eventQRScanned = 'qr_scanned';
  static const String eventQRGenerated = 'qr_generated';
  static const String eventQRShared = 'qr_shared';
  static const String eventQRExported = 'qr_exported';
  static const String eventHistoryCleared = 'history_cleared';

  // Regex Patterns
  static final RegExp urlPattern = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  static final RegExp emailPattern = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp phonePattern = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
}
