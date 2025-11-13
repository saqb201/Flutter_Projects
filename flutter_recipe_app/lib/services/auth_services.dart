import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  List<Map<String, dynamic>> _favoriteRecipes = [];

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  List<Map<String, dynamic>> get favoriteRecipes => _favoriteRecipes;

  AuthService() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;

    if (_isAuthenticated) {
      final name = prefs.getString('userName');
      final email = prefs.getString('userEmail');
      final bio = prefs.getString('userBio');

      if (name != null && email != null) {
        _currentUser = {
          'name': name,
          'email': email,
          'bio': bio ?? 'Food enthusiast who loves cooking!',
          'joinDate': '2024',
        };
      }
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock authentication - in real app, this would call your backend
    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', email.split('@')[0]);

      _isAuthenticated = true;
      _currentUser = {
        'name': email.split('@')[0],
        'email': email,
        'bio': 'Food enthusiast who loves cooking!',
        'joinDate': '2024',
      };

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock registration
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userName', name);

      _isAuthenticated = true;
      _currentUser = {
        'name': name,
        'email': email,
        'bio': 'Food enthusiast who loves cooking!',
        'joinDate': '2024',
      };

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> forgotPassword(String email) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock password reset - always return true for demo
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);

    _isAuthenticated = false;
    _currentUser = null;
    _favoriteRecipes.clear();

    notifyListeners();
  }

  void updateProfile(Map<String, dynamic> updates) {
    if (_currentUser != null) {
      _currentUser!.addAll(updates);
      notifyListeners();
    }
  }

  void toggleFavorite(Map<String, dynamic> recipe) {
    final isFavorite = _favoriteRecipes.any((r) => r['id'] == recipe['id']);

    if (isFavorite) {
      _favoriteRecipes.removeWhere((r) => r['id'] == recipe['id']);
    } else {
      _favoriteRecipes.add(recipe);
    }

    notifyListeners();
  }

  bool isFavorite(String recipeId) {
    return _favoriteRecipes.any((recipe) => recipe['id'] == recipeId);
  }
}
