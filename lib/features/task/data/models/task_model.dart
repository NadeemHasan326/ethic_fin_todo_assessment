import 'package:ethic_fin_todo_assessment/exports.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int priorityIndex;

  @HiveField(4)
  final DateTime dueDate;

  @HiveField(5)
  final bool isCompleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool isSynced;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priorityIndex,
    required this.dueDate,
    required this.isCompleted,
    required this.createdAt,
    this.isSynced = false,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      priorityIndex: entity.priority.index,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt,
      isSynced: entity.isSynced,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      priority: TaskPriority.values[priorityIndex],
      dueDate: dueDate,
      isCompleted: isCompleted,
      createdAt: createdAt,
      isSynced: isSynced,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priorityIndex: json['priorityIndex'] ?? 1,
      dueDate: DateTime.tryParse(json['dueDate'] ?? '') ?? DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priorityIndex': priorityIndex,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory TaskModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return TaskModel.fromJson({
      ...json,
      'id': docId,
      'isSynced': true,
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json.remove('isSynced');
    return json;
  }
}
