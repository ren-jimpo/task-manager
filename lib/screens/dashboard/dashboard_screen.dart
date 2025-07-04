import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/colors.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../widgets/task_card.dart';
import '../../widgets/progress_circle.dart';
import '../../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        if (taskProvider.tasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final statusCounts = taskProvider.taskStatusCounts;
        final todayTasks = taskProvider.todayTasks;
        final overdueTasks = taskProvider.overdueTasks;
        final overallProgress = taskProvider.overallProgress;

        return RefreshIndicator(
          onRefresh: () async {
            await taskProvider.loadMockData();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 概要統計
                _buildOverviewSection(context, statusCounts, overallProgress),
                const SizedBox(height: 24),

                // 今日のタスク
                _buildTodayTasksSection(context, todayTasks),
                const SizedBox(height: 24),

                // 期限超過タスク
                if (overdueTasks.isNotEmpty) ...[
                  _buildOverdueTasksSection(context, overdueTasks),
                  const SizedBox(height: 24),
                ],

                // カテゴリ別統計
                _buildCategoryStatsSection(context, taskProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverviewSection(
    BuildContext context,
    Map<String, int> statusCounts,
    double overallProgress,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '概要',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // 全体進捗率
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(
            children: [
              ProgressCircle(
                progress: overallProgress,
                size: 80,
                strokeWidth: 8,
                backgroundColor: AppColors.borderLight,
                progressColor: AppColors.primary,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '全体の進捗',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${overallProgress.round()}% 完了',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${statusCounts['completed']}/${statusCounts['total']} タスク完了',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ステータス別統計
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'To Do',
                value: '${statusCounts['todo']}',
                color: AppColors.todoStatus,
                icon: Icons.schedule,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'In Progress',
                value: '${statusCounts['inProgress']}',
                color: AppColors.inProgressStatus,
                icon: Icons.work_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'In Review',
                value: '${statusCounts['inReview']}',
                color: AppColors.inReviewStatus,
                icon: Icons.rate_review_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Completed',
                value: '${statusCounts['completed']}',
                color: AppColors.completedStatus,
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayTasksSection(BuildContext context, List<Task> todayTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '今日のタスク',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (todayTasks.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${todayTasks.length}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (todayTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '今日のタスクはありません',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'お疲れ様でした！',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...todayTasks.take(3).map((task) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TaskCard(
              task: task,
              onTap: () {
                // TODO: タスク詳細画面に遷移
              },
            ),
          )).toList(),
        
        if (todayTasks.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              onPressed: () {
                // TODO: 全ての今日のタスクを表示
              },
              child: Text('他 ${todayTasks.length - 3} 件のタスクを表示'),
            ),
          ),
      ],
    );
  }

  Widget _buildOverdueTasksSection(BuildContext context, List<Task> overdueTasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '期限超過',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${overdueTasks.length}',
                style: const TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        ...overdueTasks.take(3).map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskCard(
            task: task,
            isOverdue: true,
            onTap: () {
              // TODO: タスク詳細画面に遷移
            },
          ),
        )).toList(),
        
        if (overdueTasks.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              onPressed: () {
                // TODO: 全ての期限超過タスクを表示
              },
              child: Text('他 ${overdueTasks.length - 3} 件の期限超過タスクを表示'),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryStatsSection(BuildContext context, TaskProvider taskProvider) {
    final categoryStats = <TaskCategory, Map<String, int>>{};
    
    for (final category in TaskCategory.values) {
      final categoryTasks = taskProvider.tasks.where((task) => task.category == category).toList();
      categoryStats[category] = {
        'total': categoryTasks.length,
        'completed': categoryTasks.where((t) => t.status == TaskStatus.completed).length,
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'カテゴリ別進捗',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        ...categoryStats.entries.map((entry) {
          final category = entry.key;
          final stats = entry.value;
          final total = stats['total']!;
          final completed = stats['completed']!;
          final progress = total > 0 ? (completed / total) * 100 : 0.0;
          
          Color categoryColor;
          switch (category) {
            case TaskCategory.zemi:
              categoryColor = AppColors.categoryZemi;
              break;
            case TaskCategory.job:
              categoryColor = AppColors.categoryJob;
              break;
            case TaskCategory.work:
              categoryColor = AppColors.categoryWork;
              break;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$completed/$total',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
} 