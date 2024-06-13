// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 3;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      isThemeMode: fields[0] as bool,
      isGridMode: fields[1] as bool,
      selectedFont: fields[3] as SelectedFont,
      sortedTime: fields[4] as SortedTime,
      fontSizeSlider: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isThemeMode)
      ..writeByte(1)
      ..write(obj.isGridMode)
      ..writeByte(2)
      ..write(obj.fontSizeSlider)
      ..writeByte(3)
      ..write(obj.selectedFont)
      ..writeByte(4)
      ..write(obj.sortedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
