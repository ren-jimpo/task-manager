import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final bool isOverdue;
  final bool showProgress;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.isOverdue = false,
    this.showProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);
    final statusColor = _getStatusColor(task.status);
    final categoryColor = _getCategoryColor(task.category);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOverdue ? AppColors.error.withOpacity(0.3) : Colors.transparent,
              width: isOverdue ? 2 : 0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ヘッダー行
              Row(
                children: [
                  // 優先度インジケーター
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // タスク名
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  // ステータスバッジ
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(task.status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              // 説明文（もしあれば）
              if (task.description != null && task.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              
              // 進捗バー（サブタスクがある場合）
              if (showProgress && task.subTasks.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: task.progressPercentage / 100,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${task.progressPercentage.round()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              
              // フッター行
              Row(
                children: [
                  // カテゴリ
                  Icon(
                    _getCategoryIcon(task.category),
                    size: 14,
                    color: categoryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.category.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 期日
                  if (task.dueDate != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: isOverdue 
                          ? AppColors.error 
                          : task.isDueToday 
                              ? AppColors.warning 
                              : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MM/dd').format(task.dueDate!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isOverdue 
                            ? AppColors.error 
                            : task.isDueToday 
                                ? AppColors.warning 
                                : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  
                  // 担当者（もしあれば）
                  if (task.assignee != null && task.assignee!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        task.assignee!.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              // タグ（もしあれば）
              if (task.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: task.tags.take(3).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.high:
        return Colors.orange;
      case TaskPriority.urgent:
        return AppColors.error;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.inReview:
        return AppColors.warning;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.onHold:
        return AppColors.error;
    }
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.zemi:
        return AppColors.primary;
      case TaskCategory.job:
        return AppColors.warning;
      case TaskCategory.work:
        return AppColors.success;
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.zemi:
        return Icons.school;
      case TaskCategory.job:
        return Icons.work;
      case TaskCategory.work:
        return Icons.business;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return '未着手';
      case TaskStatus.inProgress:
        return '進行中';
      case TaskStatus.inReview:
        return 'レビュー中';
      case TaskStatus.completed:
        return '完了';
      case TaskStatus.onHold:
        return '保留';
    }
  }
} 