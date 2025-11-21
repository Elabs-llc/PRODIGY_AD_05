// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QRCodeModelAdapter extends TypeAdapter<QRCodeModel> {
  @override
  final int typeId = 0;

  @override
  QRCodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QRCodeModel(
      id: fields[0] as String?,
      data: fields[1] as String,
      type: fields[2] as QRCodeType,
      createdAt: fields[3] as DateTime?,
      scannedAt: fields[4] as DateTime?,
      isGenerated: fields[5] as bool,
      title: fields[6] as String?,
      notes: fields[7] as String?,
      isFavorite: fields[8] as bool,
      color: fields[9] as int?,
      customization: (fields[10] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, QRCodeModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.scannedAt)
      ..writeByte(5)
      ..write(obj.isGenerated)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.isFavorite)
      ..writeByte(9)
      ..write(obj.color)
      ..writeByte(10)
      ..write(obj.customization);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRCodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QRCodeTypeAdapter extends TypeAdapter<QRCodeType> {
  @override
  final int typeId = 1;

  @override
  QRCodeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QRCodeType.text;
      case 1:
        return QRCodeType.url;
      case 2:
        return QRCodeType.email;
      case 3:
        return QRCodeType.phone;
      case 4:
        return QRCodeType.wifi;
      case 5:
        return QRCodeType.contact;
      case 6:
        return QRCodeType.event;
      case 7:
        return QRCodeType.location;
      case 8:
        return QRCodeType.sms;
      default:
        return QRCodeType.text;
    }
  }

  @override
  void write(BinaryWriter writer, QRCodeType obj) {
    switch (obj) {
      case QRCodeType.text:
        writer.writeByte(0);
        break;
      case QRCodeType.url:
        writer.writeByte(1);
        break;
      case QRCodeType.email:
        writer.writeByte(2);
        break;
      case QRCodeType.phone:
        writer.writeByte(3);
        break;
      case QRCodeType.wifi:
        writer.writeByte(4);
        break;
      case QRCodeType.contact:
        writer.writeByte(5);
        break;
      case QRCodeType.event:
        writer.writeByte(6);
        break;
      case QRCodeType.location:
        writer.writeByte(7);
        break;
      case QRCodeType.sms:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QRCodeTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
