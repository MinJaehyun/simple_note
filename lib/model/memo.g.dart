// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoModelAdapter extends TypeAdapter<MemoModel> {
  @override
  final int typeId = 1;

  @override
  MemoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoModel(
      createdAt: fields[0] as DateTime,
      title: fields[1] as String,
      mainText: fields[2] as String?,
      selectedCategory: fields[3] as String?,
      startTime: fields[4] as DateTime?,
      endTime: fields[5] as DateTime?,
      isFavoriteMemo: fields[6] as bool?,
      isCheckedTodo: fields[7] as bool?,
      imagePath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MemoModel obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.isFavoriteMemo)
      ..writeByte(7)
      ..write(obj.isCheckedTodo)
      ..writeByte(8)
      ..write(obj.imagePath);
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
