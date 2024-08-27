// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 3;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      name: fields[0] as String?,
      startDate: fields[1] as DateTime?,
      endDate: fields[2] as DateTime?,
      description: fields[3] as String?,
      payment: fields[4] as String?,
      status: fields[5] as StatusTask?,
      executor: fields[6] as Executor?,
      id: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.payment)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.executor)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExecutorAdapter extends TypeAdapter<Executor> {
  @override
  final int typeId = 4;

  @override
  Executor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Executor(
      name: fields[0] as String?,
      position: fields[1] as String?,
      imagePath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Executor obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.position)
      ..writeByte(2)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExecutorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusTaskAdapter extends TypeAdapter<StatusTask> {
  @override
  final int typeId = 5;

  @override
  StatusTask read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatusTask.toDo;
      case 1:
        return StatusTask.inProgress;
      case 2:
        return StatusTask.done;
      default:
        return StatusTask.toDo;
    }
  }

  @override
  void write(BinaryWriter writer, StatusTask obj) {
    switch (obj) {
      case StatusTask.toDo:
        writer.writeByte(0);
        break;
      case StatusTask.inProgress:
        writer.writeByte(1);
        break;
      case StatusTask.done:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
