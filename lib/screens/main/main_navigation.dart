import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../tasks/tasks_screen.dart';
import '../projects/projects_screen.dart';
import '../calendar/calendar_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      title: 'ダッシュボード',
    ),
    NavigationItem(
      icon: Icons.task_outlined,
      activeIcon: Icons.task,
      label: 'Tasks',
      title: 'タスク',
    ),
    NavigationItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      label: 'Projects',
      title: 'プロジェクト',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Calendar',
      title: 'カレンダー',
    ),
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DashboardScreen(),
      const TasksScreen(),
      const ProjectsScreen(),
      const CalendarScreen(),
    ];
    
    // データを初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).loadMockData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ハンドル
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // ユーザー情報
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    authProvider.currentUserName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(authProvider.currentUserName ?? 'ユーザー'),
                subtitle: const Text('デモアカウント'),
              ),
            ),
            const Divider(),
            
            // ログアウト
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('ログアウト'),
              titleTextStyle: const TextStyle(
                color: AppColors.error,
                fontSize: 16,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_navigationItems[_selectedIndex].title),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.border,
        actions: [
          // 検索ボタン
          IconButton(
            onPressed: () {
              // TODO: 検索機能を実装
            },
            icon: const Icon(Icons.search),
          ),
          // プロフィールボタン
          IconButton(
            onPressed: _showProfileMenu,
            icon: Consumer<AuthProvider>(
              builder: (context, authProvider, _) => CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  authProvider.currentUserName?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavigationTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          items: _navigationItems.map((item) {
            final isSelected = _navigationItems.indexOf(item) == _selectedIndex;
            return BottomNavigationBarItem(
              icon: Icon(isSelected ? item.activeIcon : item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: _selectedIndex == 1 // タスク画面のみ
          ? FloatingActionButton(
              onPressed: () {
                // TODO: 新しいタスク作成画面を表示
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String title;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.title,
  });
} 