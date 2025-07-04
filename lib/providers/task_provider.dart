import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../utils/mock_data.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Project> _projects = [];
  TaskCategory? _selectedCategory;
  String _searchQuery = '';

  List<Task> get tasks => _tasks;
  List<Project> get projects => _projects;
  TaskCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // フィルタされたタスク
  List<Task> get filteredTasks {
    var filtered = _tasks;

    // カテゴリフィルター
    if (_selectedCategory != null) {
      filtered = filtered.where((task) => task.category == _selectedCategory).toList();
    }

    // 検索フィルター
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) => 
        task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
        task.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }

    return filtered;
  }

  // ステータス別タスク
  List<Task> getTasksByStatus(TaskStatus status) {
    return filteredTasks.where((task) => task.status == status).toList();
  }

  // 今日のタスク
  List<Task> get todayTasks {
    return _tasks.where((task) => task.isDueToday).toList();
  }

  // 期限超過タスク
  List<Task> get overdueTasks {
    return _tasks.where((task) => task.isOverdue).toList();
  }

  // 全体の進捗率
  double get overallProgress {
    if (_tasks.isEmpty) return 0.0;
    final completedTasks = _tasks.where((t) => t.status == TaskStatus.completed).length;
    return (completedTasks / _tasks.length) * 100;
  }

  // ステータス別カウント
  Map<String, int> get taskStatusCounts {
    return {
      'total': _tasks.length,
      'todo': _tasks.where((t) => t.status == TaskStatus.todo).length,
      'inProgress': _tasks.where((t) => t.status == TaskStatus.inProgress).length,
      'inReview': _tasks.where((t) => t.status == TaskStatus.inReview).length,
      'completed': _tasks.where((t) => t.status == TaskStatus.completed).length,
    };
  }

  /// モックデータをロード
  Future<void> loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // ローディングをシミュレート
    _tasks = MockData.tasks;
    _projects = MockData.projects;
    notifyListeners();
  }

  /// タスクを追加
  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  /// タスクを更新
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  /// タスクを削除
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  /// タスクのステータスを変更
  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = _tasks[taskIndex].copyWith(status: newStatus);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  /// サブタスクの完了状態を変更
  void toggleSubTask(String taskId, String subTaskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final task = _tasks[taskIndex];
      final subTaskIndex = task.subTasks.indexWhere((st) => st.id == subTaskId);
      if (subTaskIndex != -1) {
        final updatedSubTasks = List<SubTask>.from(task.subTasks);
        updatedSubTasks[subTaskIndex] = updatedSubTasks[subTaskIndex].copyWith(
          isCompleted: !updatedSubTasks[subTaskIndex].isCompleted,
        );
        _tasks[taskIndex] = task.copyWith(subTasks: updatedSubTasks);
        notifyListeners();
      }
    }
  }

  /// プロジェクトを追加
  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  /// プロジェクトを更新
  void updateProject(Project updatedProject) {
    final index = _projects.indexWhere((project) => project.id == updatedProject.id);
    if (index != -1) {
      _projects[index] = updatedProject;
      notifyListeners();
    }
  }

  /// プロジェクトを削除
  void deleteProject(String projectId) {
    _projects.removeWhere((project) => project.id == projectId);
    _tasks.removeWhere((task) => task.projectId == projectId);
    notifyListeners();
  }

  /// カテゴリフィルターを設定
  void setSelectedCategory(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// 検索クエリを設定
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// フィルターをクリア
  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    notifyListeners();
  }

  /// カテゴリを設定（文字列版）
  void setCategory(String? category) {
    if (category == null) {
      _selectedCategory = null;
    } else {
      switch (category) {
        case 'ゼミ':
          _selectedCategory = TaskCategory.zemi;
          break;
        case '就活':
          _selectedCategory = TaskCategory.job;
          break;
        case '会社':
          _selectedCategory = TaskCategory.work;
          break;
        default:
          _selectedCategory = null;
      }
    }
    notifyListeners();
  }

  /// プロジェクト名を取得する（デフォルト実装）
  String getProjectName(String projectId) {
    // TODO: ProjectProviderと連携して実際のプロジェクト名を取得
    return 'プロジェクト $projectId';
  }

  /// プロジェクトのタスクを取得
  List<Task> getTasksForProject(String projectId) {
    final project = _projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => Project(id: '', name: '', category: TaskCategory.work),
    );
    return _tasks.where((task) => project.taskIds.contains(task.id)).toList();
  }

  /// プロジェクトIDでタスクを取得（別名メソッド）
  List<Task> getTasksByProject(String projectId) {
    return getTasksForProject(projectId);
  }

  /// カテゴリをクリア
  void clearCategory() {
    _selectedCategory = null;
    notifyListeners();
  }

  /// IDからタスクを取得
  Task? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
} 