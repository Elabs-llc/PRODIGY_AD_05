import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/local_storage_service.dart';
import '../models/qr_code_model.dart';

/// Implementation of QR Repository
class QRRepositoryImpl implements QRRepository {
  final LocalStorageService _localStorageService;

  QRRepositoryImpl(this._localStorageService);

  @override
  Future<Either<Failure, void>> saveQRCode(QRCodeModel qrCode) async {
    try {
      await _localStorageService.saveQRCode(qrCode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<QRCodeModel>>> getAllQRCodes() async {
    try {
      final codes = await _localStorageService.getAllQRCodes();
      return Right(codes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, QRCodeModel?>> getQRCode(String id) async {
    try {
      final code = await _localStorageService.getQRCode(id);
      return Right(code);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQRCode(QRCodeModel qrCode) async {
    try {
      await _localStorageService.updateQRCode(qrCode);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQRCode(String id) async {
    try {
      await _localStorageService.deleteQRCode(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearHistory() async {
    try {
      await _localStorageService.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<QRCodeModel>>> getFavorites() async {
    try {
      final codes = await _localStorageService.getFavorites();
      return Right(codes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<QRCodeModel>>> searchQRCodes(String query) async {
    try {
      final codes = await _localStorageService.searchQRCodes(query);
      return Right(codes);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }
}
