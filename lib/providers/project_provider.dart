import 'package:flutter/foundation.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

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
    notifyListeners();
  }

  /// IDからプロジェクトを取得
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  /// プロジェクト名を取得
  String getProjectName(String projectId) {
    final project = getProjectById(projectId);
    return project?.name ?? '不明なプロジェクト';
  }
} 