import 'task.dart';

class Project {
  final String id;
  final String name;
  final String? description;
  final TaskCategory category;
  final String color;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> taskIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project({
    required this.id,
    required this.name,
    this.description,
    required this.category,
    this.color = 'blue',
    this.startDate,
    this.endDate,
    this.taskIds = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? id,
    String? name,
    String? description,
    TaskCategory? category,
    String? color,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? taskIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      color: color ?? this.color,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      taskIds: taskIds ?? this.taskIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project &&
           other.id == id &&
           other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
} 