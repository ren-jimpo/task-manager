import 'package:flutter/foundation.dart';

enum TaskStatus {
  todo('ToDo'),
  inProgress('進行中'),
  inReview('In Review'),
  completed('完了'),
  onHold('保留中');

  const TaskStatus(this.label);
  final String label;
}

enum TaskPriority {
  low('低', 1),
  medium('中', 2),
  high('高', 3),
  urgent('緊急', 4);

  const TaskPriority(this.label, this.value);
  final String label;
  final int value;
}

enum TaskCategory {
  zemi('ゼミ'),
  job('就活'),
  work('会社');

  const TaskCategory(this.label);
  final String label;
}

class SubTask {
  final String id;
  final String title;
  final bool isCompleted;

  SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  SubTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskStatus status;
  final TaskPriority priority;
  final TaskCategory category;
  final List<SubTask> subTasks;
  final List<String> tags;
  final String? assignee;
  final String? projectId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    required this.category,
    this.subTasks = const [],
    this.tags = const [],
    this.assignee,
    this.projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  double get progressPercentage {
    if (subTasks.isEmpty) {
      return status == TaskStatus.completed ? 100.0 : 0.0;
    }
    
    final completedCount = subTasks.where((task) => task.isCompleted).length;
    return (completedCount / subTasks.length) * 100;
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && status != TaskStatus.completed;
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final today = DateTime.now();
    final due = dueDate!;
    return today.year == due.year &&
           today.month == due.month &&
           today.day == due.day;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskStatus? status,
    TaskPriority? priority,
    TaskCategory? category,
    List<SubTask>? subTasks,
    List<String>? tags,
    String? assignee,
    String? projectId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      subTasks: subTasks ?? this.subTasks,
      tags: tags ?? this.tags,
      assignee: assignee ?? this.assignee,
      projectId: projectId ?? this.projectId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
           other.id == id &&
           other.title == title &&
           other.status == status;
  }

  @override
  int get hashCode => Object.hash(id, title, status);
} 