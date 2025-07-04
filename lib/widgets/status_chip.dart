import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';

class StatusChip extends StatelessWidget {
  final TaskStatus status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusData.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusData.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusData.icon,
            size: 16,
            color: statusData.color,
          ),
          const SizedBox(width: 4),
          Text(
            statusData.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusData.color,
            ),
          ),
        ],
      ),
    );
  }

  StatusData _getStatusData(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return StatusData('未着手', Icons.radio_button_unchecked, AppColors.textSecondary);
      case TaskStatus.inProgress:
        return StatusData('進行中', Icons.play_circle_outline, AppColors.primary);
      case TaskStatus.inReview:
        return StatusData('レビュー中', Icons.visibility_outlined, AppColors.warning);
      case TaskStatus.completed:
        return StatusData('完了', Icons.check_circle_outline, AppColors.success);
      case TaskStatus.onHold:
        return StatusData('保留', Icons.pause_circle_outline, Colors.orange);
    }
  }
}

class StatusData {
  final String label;
  final IconData icon;
  final Color color;

  StatusData(this.label, this.icon, this.color);
} 