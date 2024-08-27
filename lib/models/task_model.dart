import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 3)
class Task extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  DateTime? startDate;

  @HiveField(2)
  DateTime? endDate;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? payment;

  @HiveField(5)
  StatusTask? status;

  @HiveField(6)
  Executor? executor;

  @HiveField(7)
  String? id;

  Task({
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.payment,
    this.status,
    this.executor,
    this.id,
  });

  @override
  String toString() {
    return 'Project(name: $name, startDate: $startDate, endDate: $endDate, description: $description, budgetAllocations: $payment, status: $status, teamMembers: $executor, id: $id)';
  }
}

@HiveType(typeId: 4)
class Executor extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? position;

  @HiveField(2)
  String? imagePath;

  Executor({
    this.name,
    this.position,
    this.imagePath,
  });

  @override
  String toString() {
    return 'TeamMember(name: $name, position: $position, imagePath: $imagePath)';
  }
}

@HiveType(typeId: 5)
enum StatusTask {
  @HiveField(0)
  toDo,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  done,
}

extension StatusTaskExtension on StatusTask {
  String getItem({String defaultValue = ''}) {
    switch (this) {
      case StatusTask.toDo:
        return 'To do';
      case StatusTask.inProgress:
        return 'In progress';
      case StatusTask.done:
        return 'Done';
      default:
        return defaultValue;
    }
  }
}