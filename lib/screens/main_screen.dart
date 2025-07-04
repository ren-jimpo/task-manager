import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../constants/colors.dart';
import '../models/task.dart';
import 'dashboard/dashboard_screen.dart';
import 'tasks/tasks_screen.dart';
import 'projects/projects_screen.dart';
import 'calendar/calendar_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  bool _isSidebarExpanded = true;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.task_outlined,
      selectedIcon: Icons.task,
      label: 'Tasks',
    ),
    NavigationItem(
      icon: Icons.folder_outlined,
      selectedIcon: Icons.folder,
      label: 'Projects',
    ),
    NavigationItem(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Calendar',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarExpanded ? 250 : 60,
            child: _buildSidebar(),
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937), // ダークグレー背景
      ),
      child: Column(
        children: [
          // プロフィールヘッダー
          Container(
            height: 100,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  backgroundImage: null, // プロフィール画像があれば使用
                  child: const Text(
                    'R',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ren-jimpo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Member',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // ナビゲーション
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ...List.generate(_navigationItems.length, (index) {
                  final item = _navigationItems[index];
                  final isSelected = _selectedIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _selectedIndex = index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.primary.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected 
                                ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
                                : null,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? item.selectedIcon : item.icon,
                                color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
                                size: 22,
                              ),
                              if (_isSidebarExpanded) ...[
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                
                if (_isSidebarExpanded) ...[
                  const SizedBox(height: 24),
                  // 追加ナビゲーション項目
                  _buildSidebarSection('ANALYZE'),
                  const SizedBox(height: 12),
                  _buildNavItem('Analyze chat', Icons.analytics_outlined, false),
                  
                  const SizedBox(height: 24),
                  _buildSidebarSection('COLLABORATION'),
                  const SizedBox(height: 12),
                  _buildNavItem('Team', Icons.group_outlined, false),
                  _buildNavItem('Chat', Icons.chat_outlined, false),
                  
                  const SizedBox(height: 24),
                  _buildSidebarSection('PRODUCTIVITY'),
                  const SizedBox(height: 12),
                  _buildNavItem('Assist', Icons.auto_awesome_outlined, false),
                ],
              ],
            ),
          ),
          
          // 設定
          Container(
            margin: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: const Color(0xFF9CA3AF),
                        size: 22,
                      ),
                      if (_isSidebarExpanded) ...[
                        const SizedBox(width: 14),
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // アップグレードセクション
          if (_isSidebarExpanded) _buildUpgradeSection(),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF6B7280),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.primary : const Color(0xFF9CA3AF),
                  size: 20,
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4B5563),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Upgrade to Pro',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Unlock advanced AI features, unlimited projects, and priority support.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upgrade Now',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Quick Actions
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Color(0xFF9CA3AF),
                        size: 16,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Task',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        color: Color(0xFF9CA3AF),
                        size: 16,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Project',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: const Color(0xFF9CA3AF),
                size: 16,
              ),
              const SizedBox(width: 8),
              const Text(
                'Help & Support',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSidebarExpanded = !_isSidebarExpanded;
              });
            },
            icon: Icon(
              _isSidebarExpanded ? Icons.menu_open : Icons.menu,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              _getPageTitle(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildQuickStats(),
          const SizedBox(width: 20),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textSecondary,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: const Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final tasks = taskProvider.tasks;
        final totalTasks = tasks.length;
        final inProgressTasks = tasks.where((task) => task.status == TaskStatus.inProgress).length;
        final completedTasks = tasks.where((task) => task.status == TaskStatus.completed).length;

        return Row(
          children: [
            _buildStatChip('$totalTasks Total', AppColors.textSecondary),
            const SizedBox(width: 12),
            _buildStatChip('$inProgressTasks In Progress', const Color(0xFFF59E0B)),
            const SizedBox(width: 12),
            _buildStatChip('$completedTasks Completed', const Color(0xFF10B981)),
          ],
        );
      },
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text('Dashboard (開発中)'));
      case 1:
        return TasksScreen(isSidebarExpanded: _isSidebarExpanded);
      case 2:
        return const ProjectsScreen();
      case 3:
        return const CalendarScreen();
      default:
        return TasksScreen(isSidebarExpanded: _isSidebarExpanded);
    }
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Tasks';
      case 2:
        return 'Projects';
      case 3:
        return 'Calendar';
      default:
        return 'Tasks';
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
} 