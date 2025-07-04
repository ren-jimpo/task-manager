import '../models/task.dart';
import '../models/project.dart';

class MockData {
  static List<Task> get tasks => [
    // 各SNSの設立・方針作成
    Task(
      id: '1',
      title: '各SNSの設立・方針作成',
      description: 'X・Instagram・YouTubeのアカウントを作成し、動画などを投稿...',
      dueDate: DateTime(2024, 7, 6),
      status: TaskStatus.todo,
      priority: TaskPriority.medium,
      category: TaskCategory.zemi,
      assignee: 'ren-jimpo',
      projectId: 'vibeteam-project',
      subTasks: [],
      tags: ['Vibeteam release'],
    ),
    
    // UI/UX紹介動画作成
    Task(
      id: '2',
      title: 'UI/UX紹介動画作成',
      description: '実際にVibeteamを使用しながら、主要機能についてイメージ...',
      dueDate: DateTime(2024, 7, 12),
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
      category: TaskCategory.zemi,
      assignee: 'ren-jimpo',
      projectId: 'vibeteam-project',
      subTasks: [],
      tags: ['Vibeteam release'],
    ),
    
    // CSVエクスポート機能
    Task(
      id: '3',
      title: 'CSVエクスポート機能',
      description: 'データをCSV形式でエクスポートする機能の実装',
      dueDate: DateTime(2024, 7, 3),
      status: TaskStatus.inReview,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'link-ai-project',
      subTasks: [],
      tags: ['Link-AI'],
    ),
    
    // フロントエンド作成
    Task(
      id: '4',
      title: 'フロントエンド作成',
      description: '3社案（気編、天気、本部）の景\n量・アルバイトのシフト作成、〇社...',
      dueDate: DateTime(2024, 7, 4),
      status: TaskStatus.completed,
      priority: TaskPriority.high,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'shift-app-project',
      subTasks: [],
      tags: ['Shift management app'],
    ),
    
    // ピッチ資料作成
    Task(
      id: '5',
      title: 'ピッチ資料作成',
      description: 'プレゼンテーション用の資料を作成',
      dueDate: null,
      status: TaskStatus.todo,
      priority: TaskPriority.urgent,
      category: TaskCategory.zemi,
      assignee: 'Unassigned',
      projectId: 'business-plan-project',
      subTasks: [],
      tags: ['事業計画', '資金調達'],
    ),
    
    // 選択肢を固定にする
    Task(
      id: '6',
      title: '選択肢を固定にする',
      description: 'UI/UXの選択肢を固定化して一貫性を保つ',
      dueDate: null,
      status: TaskStatus.todo,
      priority: TaskPriority.high,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'link-ai-project',
      subTasks: [],
      tags: ['Link-AI'],
    ),
    
    // 機能確認・修正点列挙
    Task(
      id: '7',
      title: '機能確認・修正点列挙',
      description: 'Link-AIを実際に動かし、各機能の修正点を特定する',
      dueDate: DateTime(2024, 7, 2),
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      category: TaskCategory.work,
      assignee: 'ren-jimpo',
      projectId: 'link-ai-project',
      subTasks: [
        SubTask(id: 's1', title: '機能テスト実行', isCompleted: true),
        SubTask(id: 's2', title: '修正点のリストアップ', isCompleted: false),
      ],
      tags: ['Link-AI'],
    ),
    
    // SS管理の詳細画面実装
    Task(
      id: '8',
      title: 'SS管理の詳細画面実装',
      description: 'スクリーンショット管理機能の詳細画面UI実装',
      dueDate: DateTime(2024, 7, 3),
      status: TaskStatus.inReview,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'link-ai-project',
      subTasks: [],
      tags: ['Link-AI'],
    ),
    
    // 顧客管理機能の詳細画面実装
    Task(
      id: '9',
      title: '顧客管理機能の詳細画面実装',
      description: '顧客データ管理のための詳細画面を実装',
      dueDate: DateTime(2024, 7, 3),
      status: TaskStatus.inReview,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'link-ai-project',
      subTasks: [],
      tags: ['Link-AI'],
    ),
    
    // 要件定義書の作成
    Task(
      id: '10',
      title: '要件定義書の作成',
      description: 'Slackで受けたフィードバックからの要求のドキュメント化',
      dueDate: DateTime(2024, 7, 1),
      status: TaskStatus.completed,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'ren-jimpo',
      projectId: 'shift-app-project',
      subTasks: [
        SubTask(id: 's3', title: 'フィードバック整理', isCompleted: true),
        SubTask(id: 's4', title: '要件書作成', isCompleted: true),
        SubTask(id: 's5', title: 'レビュー実施', isCompleted: true),
      ],
      tags: ['Shift management app'],
    ),
    
    // ARR100億円を2028の事業計画
    Task(
      id: '11',
      title: 'ARR100億円を2028の事業計画',
      description: '2028年にARR100億円を達成するための詳細な事業計画書を作成',
      dueDate: null,
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      category: TaskCategory.zemi,
      assignee: 'Unassigned',
      projectId: 'business-plan-project',
      subTasks: [
        SubTask(id: 's6', title: '市場分析', isCompleted: true),
        SubTask(id: 's7', title: '収益モデル設計', isCompleted: false),
        SubTask(id: 's8', title: 'マイルストーン設定', isCompleted: false),
      ],
      tags: ['事業計画', '資金調達'],
    ),
    
    // 処理速度向上、エラー対処、ホライゾン・関数
    Task(
      id: '12',
      title: '処理速度向上、エラー対処、ホライゾン・関数',
      description: 'システム最適化とエラーハンドリングの改善',
      dueDate: null,
      status: TaskStatus.inReview,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'link-ai-project',
      subTasks: [],
      tags: ['Link-AI'],
    ),
    
    // タスク追加時にメール送信テスト
    Task(
      id: '13',
      title: 'タスク追加時にメール送信テスト',
      description: '新しいタスクが追加された際の通知機能をテスト',
      dueDate: null,
      status: TaskStatus.completed,
      priority: TaskPriority.urgent,
      category: TaskCategory.work,
      assignee: 'Unassigned',
      projectId: 'vibeteam-project',
      subTasks: [],
      tags: ['vibeteam'],
    ),
  ];

  static List<Project> get projects => [
    Project(
      id: 'vibeteam-project',
      name: 'Vibeteam リリース',
      description: 'チームコラボレーションツールのリリース準備',
      category: TaskCategory.zemi,
      startDate: DateTime(2024, 6, 1),
      endDate: DateTime(2024, 8, 31),
      taskIds: ['1', '2', '13'],
    ),
    Project(
      id: 'link-ai-project',
      name: 'Link-AI 機能拡張',
      description: 'AI機能の拡張と最適化',
      category: TaskCategory.work,
      startDate: DateTime(2024, 6, 15),
      endDate: DateTime(2024, 9, 30),
      taskIds: ['3', '6', '7', '8', '9', '12'],
    ),
    Project(
      id: 'shift-app-project',
      name: 'シフト管理アプリ',
      description: 'アルバイトシフト管理システムの開発',
      category: TaskCategory.work,
      startDate: DateTime(2024, 5, 1),
      endDate: DateTime(2024, 7, 31),
      taskIds: ['4', '10'],
    ),
    Project(
      id: 'business-plan-project',
      name: '事業計画・資金調達',
      description: '2028年ARR100億円達成のための事業計画',
      category: TaskCategory.zemi,
      startDate: DateTime(2024, 7, 1),
      endDate: DateTime(2024, 12, 31),
      taskIds: ['5', '11'],
    ),
  ];

  // 統計データ用のヘルパーメソッド
  static Map<String, int> get taskStatusCounts {
    final tasks = MockData.tasks;
    return {
      'total': tasks.length,
      'todo': tasks.where((t) => t.status == TaskStatus.todo).length,
      'inProgress': tasks.where((t) => t.status == TaskStatus.inProgress).length,
      'inReview': tasks.where((t) => t.status == TaskStatus.inReview).length,
      'completed': tasks.where((t) => t.status == TaskStatus.completed).length,
    };
  }

  static List<Task> get todayTasks {
    return tasks.where((task) => task.isDueToday).toList();
  }

  static List<Task> get overdueTasks {
    return tasks.where((task) => task.isOverdue).toList();
  }

  static double get overallProgress {
    final tasks = MockData.tasks;
    if (tasks.isEmpty) return 0.0;
    
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    
    return (completedTasks / totalTasks) * 100;
  }
} 