// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 0;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      id: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime?,
      author: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.author);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
