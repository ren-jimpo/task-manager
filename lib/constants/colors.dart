import 'package:flutter/material.dart';

class AppColors {
  // Apple HIG準拠のプライマリカラー
  static const Color primary = Color(0xFF007AFF); // iOS Blue
  static const Color secondary = Color(0xFF34C759); // iOS Green
  static const Color accent = Color(0xFFFF9500); // iOS Orange
  
  // システムカラー
  static const Color background = Color(0xFFF2F2F7); // iOS Background
  static const Color surface = Color(0xFFFFFFFF); // Surface White
  static const Color surfaceSecondary = Color(0xFFF2F2F7); // Secondary Surface
  static const Color cardBackground = Color(0xFFF9F9F9); // Card Background
  
  // テキストカラー
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFFC7C7CC);
  
  // ボーダーカラー
  static const Color border = Color(0xFFE5E5EA);
  static const Color borderLight = Color(0xFFF2F2F7);
  
  // ステータスカラー
  static const Color error = Color(0xFFFF3B30); // iOS Red
  static const Color warning = Color(0xFFFF9500); // iOS Orange
  static const Color success = Color(0xFF34C759); // iOS Green
  static const Color info = Color(0xFF007AFF); // iOS Blue
  
  // タスクステータスカラー
  static const Color todoStatus = Color(0xFF8E8E93); // Gray
  static const Color inProgressStatus = Color(0xFF007AFF); // Blue
  static const Color inReviewStatus = Color(0xFFFF9500); // Orange
  static const Color completedStatus = Color(0xFF34C759); // Green
  
  // 優先度カラー
  static const Color priorityLow = Color(0xFF34C759); // Green
  static const Color priorityMedium = Color(0xFFFF9500); // Orange
  static const Color priorityHigh = Color(0xFFFF3B30); // Red
  static const Color priorityUrgent = Color(0xFF5856D6); // Purple
  
  // カテゴリカラー
  static const Color categoryZemi = Color(0xFF007AFF); // Blue
  static const Color categoryJob = Color(0xFFFF9500); // Orange
  static const Color categoryWork = Color(0xFF34C759); // Green
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        background: AppColors.background,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.border,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        shadowColor: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
} 