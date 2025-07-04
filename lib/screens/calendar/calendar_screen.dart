import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../providers/task_provider.dart';
import '../../constants/colors.dart';
import '../../models/task.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Task>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Task> _getEventsForDay(DateTime day) {
    final taskProvider = context.read<TaskProvider>();
    return taskProvider.tasks.where((task) {
      if (task.dueDate == null) return false;
      return isSameDay(task.dueDate, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
            },
            icon: const Icon(Icons.today),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              _buildCalendar(taskProvider),
              const SizedBox(height: 8),
              Expanded(
                child: _buildEventsList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar(TaskProvider taskProvider) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: TableCalendar<Task>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _selectedEvents.value = _getEventsForDay(selectedDay);
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          markerDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 3,
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    return ValueListenableBuilder<List<Task>>(
      valueListenable: _selectedEvents,
      builder: (context, events, _) {
        if (events.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final task = events[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.status == TaskStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (task.description != null && task.description!.isNotEmpty)
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(task.priority).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getPriorityText(task.priority),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(task.priority),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(task.category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.category.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getCategoryColor(task.category),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    _showTaskStatusDialog(task);
                  },
                  icon: Icon(
                    task.status == TaskStatus.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.status == TaskStatus.completed
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
                onTap: () => _showTaskDetails(task),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '選択した日にタスクはありません',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
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

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return '低';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.high:
        return '高';
      case TaskPriority.urgent:
        return '緊急';
    }
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textTertiary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (task.description != null && task.description!.isNotEmpty) ...[
                    Text(
                      '説明',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _buildTaskDetailRow('カテゴリ', task.category.label),
                  _buildTaskDetailRow('優先度', _getPriorityText(task.priority)),
                  _buildTaskDetailRow('ステータス', _getStatusText(task.status)),
                  if (task.dueDate != null)
                    _buildTaskDetailRow('期限', _formatDate(task.dueDate!)),
                  if (task.assignee != null)
                    _buildTaskDetailRow('担当者', task.assignee!),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: タスク編集画面へ
                          },
                          child: const Text('編集'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(task);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('削除'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
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

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  void _showTaskStatusDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ステータス変更'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskStatus.values.map((status) {
            return ListTile(
              title: Text(_getStatusText(status)),
              leading: Radio<TaskStatus>(
                value: status,
                groupValue: task.status,
                onChanged: (TaskStatus? value) {
                  if (value != null) {
                    context.read<TaskProvider>().updateTaskStatus(task.id, value);
                    Navigator.pop(context);
                    setState(() {
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('タスクを削除'),
        content: Text('「${task.title}」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TaskProvider>().deleteTask(task.id);
              setState(() {
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('タスクを削除しました')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }
} 