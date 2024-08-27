// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      name: fields[0] as String?,
      startDate: fields[1] as DateTime?,
      endDate: fields[2] as DateTime?,
      description: fields[3] as String?,
      budgetAllocations: (fields[4] as List?)?.cast<String>(),
      status: fields[5] as Status?,
      teamMembers: (fields[6] as List?)?.cast<TeamMember>(),
      id: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
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
      ..write(obj.budgetAllocations)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.teamMembers)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamMemberAdapter extends TypeAdapter<TeamMember> {
  @override
  final int typeId = 1;

  @override
  TeamMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamMember(
      name: fields[0] as String?,
      position: fields[1] as String?,
      imagePath: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeamMember obj) {
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
      other is TeamMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 2;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.toDo;
      case 1:
        return Status.inProgress;
      case 2:
        return Status.done;
      default:
        return Status.toDo;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.toDo:
        writer.writeByte(0);
        break;
      case Status.inProgress:
        writer.writeByte(1);
        break;
      case Status.done:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
