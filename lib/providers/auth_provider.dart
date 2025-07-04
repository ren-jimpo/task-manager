import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;
  String? _currentUserName;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;

  /// 簡易ログイン（モック実装）
  Future<bool> login(String email, String password) async {
    // モック実装：任意のメールアドレスでログイン可能
    await Future.delayed(const Duration(seconds: 1)); // API呼び出しをシミュレート
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _currentUserId = 'user_${email.split('@')[0]}';
      _currentUserName = email.split('@')[0];
      notifyListeners();
      return true;
    }
    
    return false;
  }

  /// ログアウト
  void logout() {
    _isAuthenticated = false;
    _currentUserId = null;
    _currentUserName = null;
    notifyListeners();
  }

  /// 自動ログイン（アプリ起動時）
  Future<void> tryAutoLogin() async {
    // 実際のアプリでは、SharedPreferencesやSecure Storageから
    // 保存されたトークンを確認する
    await Future.delayed(const Duration(milliseconds: 500));
    // モック実装では何もしない
  }
} 