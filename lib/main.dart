import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/colors.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'providers/project_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
        title: 'タスク管理アプリ',
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isAuthenticated
                ? const MainScreen()
                : const LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
