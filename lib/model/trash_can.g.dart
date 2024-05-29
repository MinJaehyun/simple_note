// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trash_can.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrashCanModelAdapter extends TypeAdapter<TrashCanModel> {
  @override
  final int typeId = 2;

  @override
  TrashCanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrashCanModel(
      createdAt: fields[0] as DateTime,
      title: fields[1] as String,
      mainText: fields[2] as String?,
      selectedCategory: fields[3] as String?,
      startTime: fields[4] as DateTime?,
      endTime: fields[5] as DateTime?,
      isFavoriteMemo: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TrashCanModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.createdAt)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.mainText)
      ..writeByte(3)
      ..write(obj.selectedCategory)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.isFavoriteMemo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrashCanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
