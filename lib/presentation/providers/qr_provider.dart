import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logging/app_logger.dart';
import '../../data/datasources/local_storage_service.dart';
import '../../data/models/qr_code_model.dart';
import '../../data/repositories/qr_repository_impl.dart';

/// Provider for local storage service
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Provider for QR repository
final qrRepositoryProvider = Provider<QRRepositoryImpl>((ref) {
  final localStorageService = ref.watch(localStorageServiceProvider);
  return QRRepositoryImpl(localStorageService);
});

/// State for QR codes
class QRState {
  final List<QRCodeModel> qrCodes;
  final bool isLoading;
  final String? error;

  const QRState({
    this.qrCodes = const [],
    this.isLoading = false,
    this.error,
  });

  QRState copyWith({
    List<QRCodeModel>? qrCodes,
    bool? isLoading,
    String? error,
  }) {
    return QRState(
      qrCodes: qrCodes ?? this.qrCodes,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// QR codes notifier
class QRNotifier extends StateNotifier<QRState> {
  final QRRepositoryImpl _repository;

  QRNotifier(this._repository) : super(const QRState()) {
    loadQRCodes();
  }

  /// Load all QR codes
  Future<void> loadQRCodes() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getAllQRCodes();

    result.fold(
      (failure) {
        AppLogger.error('Failed to load QR codes: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (codes) {
        state = state.copyWith(
          qrCodes: codes,
          isLoading: false,
          error: null,
        );
      },
    );
  }

  /// Save QR code
  Future<bool> saveQRCode(QRCodeModel qrCode) async {
    final result = await _repository.saveQRCode(qrCode);

    return result.fold(
      (failure) {
        AppLogger.error('Failed to save QR code: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadQRCodes(); // Reload to update UI
        return true;
      },
    );
  }

  /// Update QR code
  Future<bool> updateQRCode(QRCodeModel qrCode) async {
    final result = await _repository.updateQRCode(qrCode);

    return result.fold(
      (failure) {
        AppLogger.error('Failed to update QR code: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadQRCodes(); // Reload to update UI
        return true;
      },
    );
  }

  /// Toggle favorite
  Future<void> toggleFavorite(QRCodeModel qrCode) async {
    final updated = qrCode.copyWith(isFavorite: !qrCode.isFavorite);
    await updateQRCode(updated);
  }

  /// Delete QR code
  Future<bool> deleteQRCode(String id) async {
    final result = await _repository.deleteQRCode(id);

    return result.fold(
      (failure) {
        AppLogger.error('Failed to delete QR code: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        loadQRCodes(); // Reload to update UI
        return true;
      },
    );
  }

  /// Clear all history
  Future<bool> clearHistory() async {
    final result = await _repository.clearHistory();

    return result.fold(
      (failure) {
        AppLogger.error('Failed to clear history: ${failure.message}');
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(qrCodes: [], error: null);
        return true;
      },
    );
  }

  /// Get favorites
  Future<List<QRCodeModel>> getFavorites() async {
    final result = await _repository.getFavorites();

    return result.fold(
      (failure) {
        AppLogger.error('Failed to get favorites: ${failure.message}');
        return [];
      },
      (codes) => codes,
    );
  }

  /// Search QR codes
  Future<List<QRCodeModel>> searchQRCodes(String query) async {
    if (query.isEmpty) {
      return state.qrCodes;
    }

    final result = await _repository.searchQRCodes(query);

    return result.fold(
      (failure) {
        AppLogger.error('Failed to search QR codes: ${failure.message}');
        return [];
      },
      (codes) => codes,
    );
  }
}

/// QR codes provider
final qrProvider = StateNotifierProvider<QRNotifier, QRState>((ref) {
  final repository = ref.watch(qrRepositoryProvider);
  return QRNotifier(repository);
});

/// Favorites provider
final favoritesProvider = FutureProvider<List<QRCodeModel>>((ref) async {
  final notifier = ref.watch(qrProvider.notifier);
  return notifier.getFavorites();
});
