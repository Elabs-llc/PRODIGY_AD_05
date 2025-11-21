import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

// Permission failures
class CameraPermissionFailure extends Failure {
  const CameraPermissionFailure({
    super.message = 'Camera permission denied',
    super.code = 'CAMERA_PERMISSION_DENIED',
  });
}

class StoragePermissionFailure extends Failure {
  const StoragePermissionFailure({
    super.message = 'Storage permission denied',
    super.code = 'STORAGE_PERMISSION_DENIED',
  });
}

// QR Code specific failures
class QRCodeGenerationFailure extends Failure {
  const QRCodeGenerationFailure({
    required super.message,
    super.code = 'QR_GENERATION_FAILED',
    super.details,
  });
}

class QRCodeScanFailure extends Failure {
  const QRCodeScanFailure({
    required super.message,
    super.code = 'QR_SCAN_FAILED',
    super.details,
  });
}

class InvalidQRDataFailure extends Failure {
  const InvalidQRDataFailure({
    super.message = 'Invalid QR code data',
    super.code = 'INVALID_QR_DATA',
    super.details,
  });
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
  });
}

// Export failures
class ExportFailure extends Failure {
  const ExportFailure({
    required super.message,
    super.code = 'EXPORT_FAILED',
    super.details,
  });
}

// Import failures
class ImportFailure extends Failure {
  const ImportFailure({
    required super.message,
    super.code = 'IMPORT_FAILED',
    super.details,
  });
}
