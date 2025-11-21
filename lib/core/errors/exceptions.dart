/// Base exception class for application-specific exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' ($code)' : ''}';
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.details,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.details,
  });
}

class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class QRCodeException extends AppException {
  const QRCodeException({
    required super.message,
    super.code,
    super.details,
  });
}
