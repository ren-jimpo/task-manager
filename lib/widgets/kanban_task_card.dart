import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';

class KanbanTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const KanbanTaskCard({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ヘッダー（優先度とカテゴリ）
                Row(
                  children: [
                    if (task.priority != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(task.priority!).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getPriorityText(task.priority!),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _getPriorityColor(task.priority!),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(task.category).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.category.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getCategoryColor(task.category),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // タスクタイトル
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (task.description != null && task.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // プログレスバー
                _buildProgressBar(),
                
                const SizedBox(height: 12),
                
                // フッター
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    // タスクの進捗率を計算（サンプル実装）
    double progress = 0.0;
    switch (task.status) {
      case TaskStatus.todo:
        progress = 0.0;
        break;
      case TaskStatus.inProgress:
        progress = 0.5; // 50%
        break;
      case TaskStatus.inReview:
        progress = 0.8; // 80%
        break;
      case TaskStatus.completed:
        progress = 1.0; // 100%
        break;
      case TaskStatus.onHold:
        progress = 0.3; // 30%
        break;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: _getProgressColor(progress),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        // 最初の行：プロジェクトIDと期限
        Row(
          children: [
            if (task.projectId != null) ...[
              Icon(
                Icons.folder_outlined,
                color: const Color(0xFF6B7280),
                size: 12,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  task.projectId!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (task.dueDate != null) ...[
              if (task.projectId != null) const SizedBox(width: 12),
              Icon(
                Icons.schedule,
                color: const Color(0xFF6B7280),
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDueDate(task.dueDate!),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ],
        ),
        if (task.assignee != null) ...[
          const SizedBox(height: 8),
          // 二行目：担当者
          Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFF3B82F6).withOpacity(0.15),
                child: Text(
                  task.assignee!.isNotEmpty ? task.assignee![0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                task.assignee!,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return const Color(0xFF10B981);
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.high:
        return const Color(0xFFEF4444);
      case TaskPriority.urgent:
        return const Color(0xFF8B5CF6);
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.zemi:
        return const Color(0xFF8B5CF6);
      case TaskCategory.job:
        return const Color(0xFF06B6D4);
      case TaskCategory.work:
        return const Color(0xFF10B981);
    }
  }

  Color _getProgressColor(double progress) {
    if (progress == 0.0) {
      return const Color(0xFF6B7280);
    } else if (progress < 0.5) {
      return const Color(0xFF3B82F6); // Blue
    } else if (progress < 1.0) {
      return const Color(0xFFF59E0B); // Orange
    } else {
      return const Color(0xFF10B981); // Green
    }
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 0) {
      return '${difference}d left';
    } else {
      return '${difference.abs()}d ago';
    }
  }
} 