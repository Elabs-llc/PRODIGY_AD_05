import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../data/models/qr_code_model.dart';

/// Repository interface for QR code operations
abstract class QRRepository {
  Future<Either<Failure, void>> saveQRCode(QRCodeModel qrCode);
  Future<Either<Failure, List<QRCodeModel>>> getAllQRCodes();
  Future<Either<Failure, QRCodeModel?>> getQRCode(String id);
  Future<Either<Failure, void>> updateQRCode(QRCodeModel qrCode);
  Future<Either<Failure, void>> deleteQRCode(String id);
  Future<Either<Failure, void>> clearHistory();
  Future<Either<Failure, List<QRCodeModel>>> getFavorites();
  Future<Either<Failure, List<QRCodeModel>>> searchQRCodes(String query);
}
