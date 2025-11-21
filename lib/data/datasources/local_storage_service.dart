import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/logging/app_logger.dart';
import '../models/qr_code_model.dart';

/// Local storage service using Hive for QR codes and SharedPreferences for settings
class LocalStorageService {
  Box<QRCodeModel>? _historyBox;
  SharedPreferences? _preferences;

  /// Initialize storage
  Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Register adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(QRCodeModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(QRCodeTypeAdapter());
      }

      // Open boxes
      _historyBox = await Hive.openBox<QRCodeModel>(
        AppConstants.historyBoxName,
      );

      _preferences = await SharedPreferences.getInstance();

      AppLogger.info('Local storage initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize local storage', e, stackTrace);
      throw CacheException(
        message: 'Failed to initialize local storage: $e',
        details: stackTrace,
      );
    }
  }

  /// Save QR code to history
  Future<void> saveQRCode(QRCodeModel qrCode) async {
    try {
      await _ensureInitialized();
      await _historyBox!.put(qrCode.id, qrCode);

      // Maintain max history items
      if (_historyBox!.length > AppConstants.maxHistoryItems) {
        final oldestKey = _historyBox!.keys.first;
        await _historyBox!.delete(oldestKey);
      }

      AppLogger.debug('QR code saved to history: ${qrCode.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save QR code', e, stackTrace);
      throw CacheException(
        message: 'Failed to save QR code: $e',
        details: stackTrace,
      );
    }
  }

  /// Get all QR codes from history
  Future<List<QRCodeModel>> getAllQRCodes() async {
    try {
      await _ensureInitialized();
      final codes = _historyBox!.values.toList();

      // Sort by creation date (newest first)
      codes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return codes;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get QR codes', e, stackTrace);
      throw CacheException(
        message: 'Failed to get QR codes: $e',
        details: stackTrace,
      );
    }
  }

  /// Get QR code by ID
  Future<QRCodeModel?> getQRCode(String id) async {
    try {
      await _ensureInitialized();
      return _historyBox!.get(id);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get QR code', e, stackTrace);
      throw CacheException(
        message: 'Failed to get QR code: $e',
        details: stackTrace,
      );
    }
  }

  /// Update QR code
  Future<void> updateQRCode(QRCodeModel qrCode) async {
    try {
      await _ensureInitialized();
      await _historyBox!.put(qrCode.id, qrCode);
      AppLogger.debug('QR code updated: ${qrCode.id}');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update QR code', e, stackTrace);
      throw CacheException(
        message: 'Failed to update QR code: $e',
        details: stackTrace,
      );
    }
  }

  /// Delete QR code
  Future<void> deleteQRCode(String id) async {
    try {
      await _ensureInitialized();
      await _historyBox!.delete(id);
      AppLogger.debug('QR code deleted: $id');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to delete QR code', e, stackTrace);
      throw CacheException(
        message: 'Failed to delete QR code: $e',
        details: stackTrace,
      );
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      await _ensureInitialized();
      await _historyBox!.clear();
      AppLogger.info('History cleared');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear history', e, stackTrace);
      throw CacheException(
        message: 'Failed to clear history: $e',
        details: stackTrace,
      );
    }
  }

  /// Get favorites
  Future<List<QRCodeModel>> getFavorites() async {
    try {
      await _ensureInitialized();
      final codes = _historyBox!.values.where((code) => code.isFavorite).toList();
      codes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return codes;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get favorites', e, stackTrace);
      throw CacheException(
        message: 'Failed to get favorites: $e',
        details: stackTrace,
      );
    }
  }

  /// Search QR codes
  Future<List<QRCodeModel>> searchQRCodes(String query) async {
    try {
      await _ensureInitialized();
      final lowerQuery = query.toLowerCase();

      final codes = _historyBox!.values.where((code) {
        return code.data.toLowerCase().contains(lowerQuery) ||
            (code.title?.toLowerCase().contains(lowerQuery) ?? false) ||
            (code.notes?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();

      codes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return codes;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to search QR codes', e, stackTrace);
      throw CacheException(
        message: 'Failed to search QR codes: $e',
        details: stackTrace,
      );
    }
  }

  // Settings methods

  Future<void> setThemeMode(String mode) async {
    await _preferences?.setString(AppConstants.themeKey, mode);
  }

  String? getThemeMode() {
    return _preferences?.getString(AppConstants.themeKey);
  }

  Future<void> setLanguage(String languageCode) async {
    await _preferences?.setString(AppConstants.languageKey, languageCode);
  }

  String? getLanguage() {
    return _preferences?.getString(AppConstants.languageKey);
  }

  /// Ensure storage is initialized
  Future<void> _ensureInitialized() async {
    if (_historyBox == null || _preferences == null) {
      await init();
    }
  }

  /// Close storage
  Future<void> close() async {
    await _historyBox?.close();
    AppLogger.info('Local storage closed');
  }
}
