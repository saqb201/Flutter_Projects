import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  List<RecipeSummary> _favoriteRecipes = [];

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  List<RecipeSummary> get favoriteRecipes => _favoriteRecipes;

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

    // Load favorites from storage
    final favoritesJson = prefs.getStringList('favoriteRecipes') ?? [];
    _favoriteRecipes = favoritesJson.map((json) {
      final data = Map<String, dynamic>.from(jsonDecode(json));
      return RecipeSummary.fromJson(data);
    }).toList();

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 1500));

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
    await Future.delayed(Duration(milliseconds: 1500));

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
    await Future.delayed(Duration(milliseconds: 1500));
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);

    _isAuthenticated = false;
    _currentUser = null;

    notifyListeners();
  }

  void updateProfile(Map<String, dynamic> updates) {
    if (_currentUser != null) {
      _currentUser!.addAll(updates);
      notifyListeners();
    }
  }

  void toggleFavorite(RecipeSummary recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final isFavorite = _favoriteRecipes.any((r) => r.id == recipe.id);

    if (isFavorite) {
      _favoriteRecipes.removeWhere((r) => r.id == recipe.id);
    } else {
      _favoriteRecipes.add(recipe);
    }

    // Save to storage
    final favoritesJson = _favoriteRecipes
        .map((r) => jsonEncode(r.toJson()))
        .toList();
    await prefs.setStringList('favoriteRecipes', favoritesJson);

    notifyListeners();
  }

  bool isFavorite(String recipeId) {
    return _favoriteRecipes.any((recipe) => recipe.id == recipeId);
  }
}

// Helper method to convert RecipeSummary to JSON
extension RecipeSummaryJson on RecipeSummary {
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': title,
      'strCategory': category,
      'strArea': area,
      'strMealThumb': image,
    };
  }
}
