import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';

class PriorityChip extends StatelessWidget {
  final TaskPriority priority;

  const PriorityChip({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final priorityData = _getPriorityData(priority);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: priorityData.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: priorityData.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag,
            size: 16,
            color: priorityData.color,
          ),
          const SizedBox(width: 4),
          Text(
            priorityData.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: priorityData.color,
            ),
          ),
        ],
      ),
    );
  }

  PriorityData _getPriorityData(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return PriorityData('低', AppColors.success);
      case TaskPriority.medium:
        return PriorityData('中', AppColors.warning);
      case TaskPriority.high:
        return PriorityData('高', Colors.orange);
      case TaskPriority.urgent:
        return PriorityData('緊急', AppColors.error);
    }
  }
}

class PriorityData {
  final String label;
  final Color color;

  PriorityData(this.label, this.color);
} 