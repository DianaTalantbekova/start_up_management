import 'package:hive/hive.dart';

import 'task_model.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? startDate;

  @HiveField(2)
  DateTime? endDate;

  @HiveField(3)
  String? description;

  @HiveField(4)
  List<String>? budgetAllocations;

  @HiveField(5)
  Status? status;

  @HiveField(6)
  List<TeamMember>? teamMembers;

  @HiveField(7)
  String? id;


  Project({
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.budgetAllocations,
    this.status,
    this.teamMembers,
    this.id,
  });

  @override
  String toString() {
    return 'Project(name: $name, startDate: $startDate, endDate: $endDate, description: $description, budgetAllocations: $budgetAllocations, status: $status, teamMembers: $teamMembers, id: $id)';
  }
}

@HiveType(typeId: 1)
class TeamMember extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? position;

  @HiveField(2)
  String? imagePath;

  TeamMember({
    this.name,
    this.position,
    this.imagePath,
  });

  @override
  String toString() {
    return 'TeamMember(name: $name, position: $position, imagePath: $imagePath)';
  }
}

@HiveType(typeId: 2)
enum Status {
  @HiveField(0)
  toDo,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  done,
}

extension StatusExtension on Status {
  String getItem({String defaultValue = ''}) {
    switch (this) {
      case Status.toDo:
        return 'To do';
      case Status.inProgress:
        return 'In progress';
      case Status.done:
        return 'Done';
      default:
        return defaultValue;
    }
  }
}