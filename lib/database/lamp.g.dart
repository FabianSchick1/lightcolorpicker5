// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lamp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LampAdapter extends TypeAdapter<Lamp> {
  @override
  final int typeId = 1;

  @override
  Lamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lamp(
      lampName: fields[0] as String,
      lampIp1: fields[1] as String,
      lampRgbColor: fields[2] as String,
      lampOn: fields[3] as bool,
      isLampFirstClick: fields[4] as bool,
      lampSelected: fields[5] as bool,
      brightPerc: fields[6] as double,
      lampSelectColor: fields[7] as String,
      lampIconColor: fields[8] as String,
      lampSelectButtonColor: fields[9] as String,
      lampWW: fields[10] as bool,
      modus: fields[11] as String,
      lampIp2: fields[12] as String,
      lampIp3: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Lamp obj) {
    writer

      // Change type to write
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.lampName)
      ..writeByte(1)
      ..write(obj.lampIp1)
      ..writeByte(2)
      ..write(obj.lampRgbColor)
      ..writeByte(3)
      ..write(obj.lampOn)
      ..writeByte(4)
      ..write(obj.isLampFirstClick)
      ..writeByte(5)
      ..write(obj.lampSelected)
      ..writeByte(6)
      ..write(obj.brightPerc)
      ..writeByte(7)
      ..write(obj.lampIconColor)
      ..writeByte(8)
      ..write(obj.lampSelectColor)
      ..writeByte(9)
      ..write(obj.lampSelectButtonColor)
      ..writeByte(10)
      ..write(obj.lampWW)
      ..writeByte(11)
      ..write(obj.modus)
      ..writeByte(12)
      ..write(obj.lampIp2)
      ..writeByte(13)
      ..write(obj.lampIp3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
