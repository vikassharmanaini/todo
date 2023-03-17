// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskModal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModalAdapter extends TypeAdapter<TaskModal> {
  @override
  final int typeId = 0;

  @override
  TaskModal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModal(
      task: fields[0] as String?,
      id: fields[3] as String?,
      endtime: fields[2] as String?,
      isCompleted: fields[4] as bool,
      enddate: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(2)
      ..write(obj.endtime)
      ..writeByte(5)
      ..write(obj.enddate)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
