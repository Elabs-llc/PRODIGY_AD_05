import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/qr_validator.dart';

part 'qr_code_model.g.dart';

@HiveType(typeId: 0)
class QRCodeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String data;

  @HiveField(2)
  final QRCodeType type;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? scannedAt;

  @HiveField(5)
  final bool isGenerated;

  @HiveField(6)
  final String? title;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final bool isFavorite;

  @HiveField(9)
  final int? color;

  @HiveField(10)
  final Map<String, dynamic>? customization;

  QRCodeModel({
    String? id,
    required this.data,
    required this.type,
    DateTime? createdAt,
    this.scannedAt,
    this.isGenerated = false,
    this.title,
    this.notes,
    this.isFavorite = false,
    this.color,
    this.customization,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Creates a QR code from scanned data
  factory QRCodeModel.fromScanned(String data) {
    final dataType = _mapDataTypeToCodeType(QRValidator.detectType(data));
    return QRCodeModel(
      data: data,
      type: dataType,
      scannedAt: DateTime.now(),
      isGenerated: false,
    );
  }

  /// Creates a QR code from generated data
  factory QRCodeModel.fromGenerated(
    String data, {
    String? title,
    String? notes,
    int? color,
    Map<String, dynamic>? customization,
  }) {
    final dataType = _mapDataTypeToCodeType(QRValidator.detectType(data));
    return QRCodeModel(
      data: data,
      type: dataType,
      isGenerated: true,
      title: title,
      notes: notes,
      color: color,
      customization: customization,
    );
  }

  /// Copy with method for immutability
  QRCodeModel copyWith({
    String? data,
    QRCodeType? type,
    DateTime? createdAt,
    DateTime? scannedAt,
    bool? isGenerated,
    String? title,
    String? notes,
    bool? isFavorite,
    int? color,
    Map<String, dynamic>? customization,
  }) {
    return QRCodeModel(
      id: id,
      data: data ?? this.data,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      scannedAt: scannedAt ?? this.scannedAt,
      isGenerated: isGenerated ?? this.isGenerated,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
      color: color ?? this.color,
      customization: customization ?? this.customization,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'type': type.toString(),
      'createdAt': createdAt.toIso8601String(),
      'scannedAt': scannedAt?.toIso8601String(),
      'isGenerated': isGenerated,
      'title': title,
      'notes': notes,
      'isFavorite': isFavorite,
      'color': color,
      'customization': customization,
    };
  }

  static QRCodeType _mapDataTypeToCodeType(QRDataType dataType) {
    switch (dataType) {
      case QRDataType.url:
        return QRCodeType.url;
      case QRDataType.email:
        return QRCodeType.email;
      case QRDataType.phone:
        return QRCodeType.phone;
      case QRDataType.wifi:
        return QRCodeType.wifi;
      case QRDataType.contact:
        return QRCodeType.contact;
      case QRDataType.event:
        return QRCodeType.event;
      case QRDataType.location:
        return QRCodeType.location;
      case QRDataType.sms:
        return QRCodeType.sms;
      case QRDataType.text:
        return QRCodeType.text;
    }
  }
}

@HiveType(typeId: 1)
enum QRCodeType {
  @HiveField(0)
  text,

  @HiveField(1)
  url,

  @HiveField(2)
  email,

  @HiveField(3)
  phone,

  @HiveField(4)
  wifi,

  @HiveField(5)
  contact,

  @HiveField(6)
  event,

  @HiveField(7)
  location,

  @HiveField(8)
  sms,
}

extension QRCodeTypeExtension on QRCodeType {
  String get displayName {
    switch (this) {
      case QRCodeType.text:
        return 'Text';
      case QRCodeType.url:
        return 'URL';
      case QRCodeType.email:
        return 'Email';
      case QRCodeType.phone:
        return 'Phone';
      case QRCodeType.wifi:
        return 'WiFi';
      case QRCodeType.contact:
        return 'Contact';
      case QRCodeType.event:
        return 'Event';
      case QRCodeType.location:
        return 'Location';
      case QRCodeType.sms:
        return 'SMS';
    }
  }

  String get icon {
    switch (this) {
      case QRCodeType.text:
        return '📝';
      case QRCodeType.url:
        return '🔗';
      case QRCodeType.email:
        return '📧';
      case QRCodeType.phone:
        return '📱';
      case QRCodeType.wifi:
        return '📶';
      case QRCodeType.contact:
        return '👤';
      case QRCodeType.event:
        return '📅';
      case QRCodeType.location:
        return '📍';
      case QRCodeType.sms:
        return '💬';
    }
  }
}
