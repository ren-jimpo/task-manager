import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/progress_circle.dart';
import '../../constants/colors.dart';
import '../../models/project.dart';
import '../../models/task.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('プロジェクト'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: プロジェクト作成画面へ
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final projects = taskProvider.projects;

          if (projects.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await taskProvider.loadMockData();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildProjectCard(context, project, taskProvider),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'プロジェクトがありません',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: プロジェクト作成画面へ
            },
            child: const Text('プロジェクトを作成'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project, TaskProvider taskProvider) {
    final projectTasks = taskProvider.getTasksByProject(project.id);
    final completedTasks = projectTasks.where((task) => task.status == TaskStatus.completed).length;
    final progress = projectTasks.isEmpty ? 0.0 : (completedTasks / projectTasks.length) * 100;

    return Card(
      child: InkWell(
        onTap: () => _showProjectDetails(context, project, taskProvider),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getProjectColor(project.color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ProgressCircle(
                    progress: progress,
                    size: 40,
                    strokeWidth: 4,
                    backgroundColor: AppColors.cardBackground,
                    progressColor: _getProjectColor(project.color),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (project.description != null && project.description!.isNotEmpty) ...[
                Text(
                  project.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$completedTasks/${projectTasks.length} タスク完了',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (project.endDate != null) ...[
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(project.endDate!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProjectDetails(BuildContext context, Project project, TaskProvider taskProvider) {
    final projectTasks = taskProvider.getTasksByProject(project.id);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
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
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getProjectColor(project.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          project.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (project.description != null && project.description!.isNotEmpty) ...[
                    Text(
                      '説明',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    'タスク一覧',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (projectTasks.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.task_outlined,
                              size: 48,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'タスクがありません',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projectTasks.length,
                      itemBuilder: (context, index) {
                        final task = projectTasks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                task.status == TaskStatus.completed
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task.status == TaskStatus.completed
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    decoration: task.status == TaskStatus.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.status == TaskStatus.completed
                                        ? AppColors.textSecondary
                                        : null,
                                  ),
                                ),
                              ),
                              if (task.dueDate != null) ...[
                                const SizedBox(width: 8),
                                Text(
                                  _formatDate(task.dueDate!),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: プロジェクト編集画面へ
                          },
                          child: const Text('編集'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showDeleteConfirmation(context, project, taskProvider);
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

  void _showDeleteConfirmation(BuildContext context, Project project, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('プロジェクトを削除'),
        content: Text('「${project.name}」を削除しますか？\n関連するタスクも削除されます。この操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              taskProvider.deleteProject(project.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('プロジェクトを削除しました')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  Color _getProjectColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return AppColors.primary;
      case 'green':
        return AppColors.success;
      case 'orange':
        return AppColors.warning;
      case 'red':
        return AppColors.error;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'teal':
        return Colors.teal;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
} 