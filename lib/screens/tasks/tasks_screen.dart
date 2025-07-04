import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import '../../constants/colors.dart';
import '../../models/task.dart';
import '../../widgets/kanban_column.dart';
import '../../utils/app_colors.dart';
import '../task_detail_screen.dart';

class TasksScreen extends StatefulWidget {
  final bool? isSidebarExpanded;
  
  const TasksScreen({super.key, this.isSidebarExpanded});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: _buildKanbanBoard(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildSearchField(),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: _buildFilterButtons(),
              ),
              const SizedBox(width: 16),
              _buildNewTaskButton(),
            ],
          ),
          const SizedBox(height: 16),
          _buildCategoryFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF6B7280),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          context.read<TaskProvider>().setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterButton('All Projects', Icons.expand_more),
          const SizedBox(width: 8),
          _buildFilterButton('All Priorities', Icons.expand_more),
          const SizedBox(width: 8),
          _buildFilterButton('All Statuses', Icons.expand_more),
          const SizedBox(width: 8),
          _buildFilterButton('All Dates', Icons.expand_more),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {
              context.read<TaskProvider>().clearFilters();
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear Filters'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF6B7280),
          ),
        ],
      ),
    );
  }

  Widget _buildNewTaskButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: 新しいタスク作成
      },
      icon: const Icon(Icons.add, size: 16),
      label: const Text('New Task'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final categories = [
          CategoryFilter('Team', true, AppColors.primary),
          CategoryFilter('Personal', false, AppColors.textSecondary),
          CategoryFilter('Kanban', false, AppColors.textSecondary),
          CategoryFilter('Calendar', false, AppColors.textSecondary),
          CategoryFilter('Table', false, AppColors.textSecondary),
        ];
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...categories.map((category) => Padding(
                padding: const EdgeInsets.only(right: 24),
                child: GestureDetector(
                  onTap: () {
                    // TODO: カテゴリフィルタ処理
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: category.isSelected ? category.color.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.isSelected)
                          Icon(
                            Icons.group,
                            size: 16,
                            color: category.color,
                          ),
                        if (category.isSelected) const SizedBox(width: 4),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: category.isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: category.isSelected ? category.color : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKanbanBoard() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final todoTasks = taskProvider.getTasksByStatus(TaskStatus.todo);
        final inProgressTasks = taskProvider.getTasksByStatus(TaskStatus.inProgress);
        final inReviewTasks = taskProvider.getTasksByStatus(TaskStatus.inReview);
        final completedTasks = taskProvider.getTasksByStatus(TaskStatus.completed);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 利用可能な幅を計算
              final availableWidth = constraints.maxWidth;
              
              // サイドバーの状態を考慮してパディングとスペースを調整
              final isSidebarExpanded = widget.isSidebarExpanded ?? true;
              final horizontalPadding = isSidebarExpanded ? 20 : 32; // サイドバーが閉じている時は余裕を持たせる
              final columnSpacing = isSidebarExpanded ? 16 : 20; // カラム間のスペース
              
              // パディングとカラム間のスペースを考慮
              final totalPadding = horizontalPadding * 2;
              final totalSpacing = columnSpacing * 3;
              final usableWidth = availableWidth - totalPadding - totalSpacing;
              
              // 各カラムの幅を計算
              // サイドバーが展開されている場合: 最小250px、最大300px
              // サイドバーが閉じている場合: 最小280px、最大350px
              final minWidth = isSidebarExpanded ? 250.0 : 280.0;
              final maxWidth = isSidebarExpanded ? 300.0 : 350.0;
              double columnWidth = (usableWidth / 4).clamp(minWidth, maxWidth);
              
              // 4つのカラムが画面に収まらない場合は横スクロールを有効に
              final totalRequiredWidth = columnWidth * 4 + totalSpacing;
              final needsScroll = totalRequiredWidth > usableWidth;
              
              if (needsScroll) {
                // 横スクロールが必要な場合
                columnWidth = isSidebarExpanded ? 260.0 : 300.0;
                return SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
                  child: _buildKanbanColumns(columnWidth, columnSpacing.toDouble()),
                );
              } else {
                // 全てのカラムが画面に収まる場合
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
                  child: _buildKanbanColumns(columnWidth, columnSpacing.toDouble()),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildKanbanColumns(double columnWidth, double spacing) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final todoTasks = taskProvider.getTasksByStatus(TaskStatus.todo);
        final inProgressTasks = taskProvider.getTasksByStatus(TaskStatus.inProgress);
        final inReviewTasks = taskProvider.getTasksByStatus(TaskStatus.inReview);
        final completedTasks = taskProvider.getTasksByStatus(TaskStatus.completed);

        // サイドバーの状態に応じて高さを調整
        final isSidebarExpanded = widget.isSidebarExpanded ?? true;
        final columnHeight = isSidebarExpanded ? 650.0 : 700.0; // サイドバーが閉じている時は少し高く

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: columnWidth,
              height: columnHeight,
              child: KanbanColumn(
                title: 'To Do',
                tasks: todoTasks,
                color: const Color(0xFF6B7280),
                onTaskTap: _showTaskDetails,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
            SizedBox(width: spacing),
            SizedBox(
              width: columnWidth,
              height: columnHeight,
              child: KanbanColumn(
                title: 'In Progress',
                tasks: inProgressTasks,
                color: const Color(0xFF3B82F6),
                onTaskTap: _showTaskDetails,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
            SizedBox(width: spacing),
            SizedBox(
              width: columnWidth,
              height: columnHeight,
              child: KanbanColumn(
                title: 'In Review',
                tasks: inReviewTasks,
                color: const Color(0xFFF59E0B),
                onTaskTap: _showTaskDetails,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
            SizedBox(width: spacing),
            SizedBox(
              width: columnWidth,
              height: columnHeight,
              child: KanbanColumn(
                title: 'Completed',
                tasks: completedTasks,
                color: const Color(0xFF10B981),
                onTaskTap: _showTaskDetails,
                onTaskStatusChanged: _updateTaskStatus,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDetails(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  void _updateTaskStatus(Task task, TaskStatus newStatus) {
    context.read<TaskProvider>().updateTaskStatus(task.id, newStatus);
  }
}

class CategoryFilter {
  final String name;
  final bool isSelected;
  final Color color;

  CategoryFilter(this.name, this.isSelected, this.color);
} 