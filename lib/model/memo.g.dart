// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoModelAdapter extends TypeAdapter<MemoModel> {
  @override
  final int typeId = 0;

  @override
  MemoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoModel(
      title: fields[1] as String,
      time: fields[0] as DateTime,
      mainText: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MemoModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.mainText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
