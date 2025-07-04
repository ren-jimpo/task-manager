import 'package:flutter/material.dart';
import '../models/task.dart';
import '../constants/colors.dart';
import '../widgets/kanban_task_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Color color;
  final Function(Task) onTaskTap;
  final Function(Task, TaskStatus) onTaskStatusChanged;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.color,
    required this.onTaskTap,
    required this.onTaskStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity, // 親から渡される固定高さを使用
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: _buildTaskList(),
          ),
          _buildAddTaskButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${tasks.length}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (tasks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 12),
            Text(
              'タスクなし',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        shrinkWrap: false, // 固定高さを活用
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: KanbanTaskCard(
              task: task,
              onTap: () => onTaskTap(task),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: 新しいタスクを追加
        },
        icon: const Icon(Icons.add, size: 16),
        label: const Text('タスクを追加'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6B7280),
          side: BorderSide(
            color: const Color(0xFFD1D5DB),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
} 