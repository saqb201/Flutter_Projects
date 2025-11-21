// // lib/services/auth_services.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';

// class AuthService with ChangeNotifier {
//   // String get baseUrl {
//   //   if (kIsWeb) {
//   //     return 'http://localhost:5000/api'; // For web
//   //   } else {
//   //     return 'http://10.0.2.2:5000/api'; // For Android emulator
//   //   }
//   // }

//   bool _isAuthenticated = false;
//   Map<String, dynamic>? _currentUser;
//   String? _token;
//   List<Recipe> _favoriteRecipes = [];

//   bool get isAuthenticated => _isAuthenticated;
//   Map<String, dynamic>? get currentUser => _currentUser;
//   List<Recipe> get favoriteRecipes => List.unmodifiable(_favoriteRecipes);

//   // // ⚠️ THIS IS THE ONLY LINE YOU NEED TO CHANGE ⚠️
//   static const String baseUrl = 'http://10.0.2.2:5000/api'; // Android Emulator
//   // // For real phone: replace with your PC IP, e.g. 'http://192.168.1.105:5000/api'

//   AuthService() {
//     _loadAuthState();
//   }

//   // Add to AuthService.dart
// Future<bool> resendVerification(String email) async {
//   try {
//     final response = await http.post(
//       Uri.parse('$baseUrl/auth/resend-verification'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email}),
//     );

//     return response.statusCode == 200;
//   } catch (e) {
//     print('Resend verification error: $e');
//     return false;
//   }
// }
//   Future<void> _loadAuthState() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     final userJson = prefs.getString('user');

//     if (_token != null && userJson != null) {
//       _isAuthenticated = true;
//       _currentUser = jsonDecode(userJson);
//       await refreshFavorites();
//       notifyListeners();
//     }
//   }

//   Future<bool> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'email': email, 'password': password}),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         await _saveAuthData(data['token'], data['user']);
//         await refreshFavorites();
//         return true;
//       }
//     } catch (e) {
//       print('Login error: $e');
//     }
//     return false;
//   }

//   Future<bool> register(String name, String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'name': name, 'email': email, 'password': password}),
//       );

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         return await login(email, password);
//       }
//     } catch (e) {
//       print('Register error: $e');
//     }
//     return false;
//   }

//   Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//     await prefs.setString('user', jsonEncode(user));
//     _token = token;
//     _currentUser = user;
//     _isAuthenticated = true;
//     notifyListeners();
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     _token = null;
//     _currentUser = null;
//     _isAuthenticated = false;
//     _favoriteRecipes.clear();
//     notifyListeners();

//   print('✅ User logged out successfully');
//   }

//   Map<String, String> getAuthHeaders() {
//     return {
//       'Content-Type': 'application/json',
//       if (_token != null) 'Authorization': 'Bearer $_token',
//     };
//   }

//   bool isFavorite(String id) => _favoriteRecipes.any((r) => r.id == id);

//   Future<void> toggleFavorite(Recipe recipe) async {
//     final already = isFavorite(recipe.id);
//     try {
//       if (already) {
//         await http.delete(
//           Uri.parse('$baseUrl/recipes/favorites/${recipe.id}'),
//           headers: getAuthHeaders(),
//         );
//         _favoriteRecipes.removeWhere((r) => r.id == recipe.id);
//       } else {
//         await http.post(
//           Uri.parse('$baseUrl/recipes/favorites'),
//           headers: getAuthHeaders(),
//           body: jsonEncode(recipe.toMap()),
//         );
//         _favoriteRecipes.add(recipe);
//       }
//       notifyListeners();
//     } catch (e) {
//       print('Toggle error: $e');
//     }
//   }

//   Future<void> refreshFavorites() async {
//     if (!_isAuthenticated) return;
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/recipes/favorites'),
//         headers: getAuthHeaders(),
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final list = data['data'] ?? data['favorites'] ?? data;
//         _favoriteRecipes = (list as List)
//             .map((item) => Recipe.fromMap(item['recipe'] ?? item))
//             .toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Refresh favorites error: $e');
//     }
//   }

//   Future<bool> forgotPassword(String email) async => false; // optional
//   Future<void> updateProfile(Map<String, dynamic> updates) async {
//     /* your code */
//   }
// }

// lib/services/auth_services.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  String? _token;
  List<Recipe> _favoriteRecipes = [];

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  List<Recipe> get favoriteRecipes => List.unmodifiable(_favoriteRecipes);

  static const String baseUrl = 'http://10.0.2.2:5000/api';

  AuthService() {
    _loadAuthState();
  }

  Future<bool> resendVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Resend verification error: $e');
      return false;
    }
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (_token != null && userJson != null) {
      _isAuthenticated = true;
      _currentUser = jsonDecode(userJson);
      await refreshFavorites();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        // Save auth data if verification successful
        await _saveAuthData(data['token'], data['user']);
        await refreshFavorites();
      }

      return data;
    } catch (e) {
      print('Verify code error: $e');
      return {'success': false, 'message': 'Verification failed'};
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuthData(data['token'], data['user']);
        await refreshFavorites();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      print('🔄 Registering user: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      print('📡 Register response: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('✅ Registration successful: ${data['message']}');
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        print('❌ Registration failed: ${errorData['message']}');
        return false;
      }
    } catch (e) {
      print('💥 Register error: $e');
      return false;
    }
  } // ✅ REMOVE THE EXTRA BRACE AFTER THIS LINE

  Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user));
    _token = token;
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _token = null;
    _currentUser = null;
    _isAuthenticated = false;
    _favoriteRecipes.clear();
    notifyListeners();

    print('✅ User logged out successfully');
  }

  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  bool isFavorite(String id) => _favoriteRecipes.any((r) => r.id == id);

  Future<void> toggleFavorite(Recipe recipe) async {
    final already = isFavorite(recipe.id);
    try {
      if (already) {
        await http.delete(
          Uri.parse('$baseUrl/recipes/favorites/${recipe.id}'),
          headers: getAuthHeaders(),
        );
        _favoriteRecipes.removeWhere((r) => r.id == recipe.id);
      } else {
        await http.post(
          Uri.parse('$baseUrl/recipes/favorites'),
          headers: getAuthHeaders(),
          body: jsonEncode(recipe.toMap()),
        );
        _favoriteRecipes.add(recipe);
      }
      notifyListeners();
    } catch (e) {
      print('Toggle error: $e');
    }
  }

  Future<void> refreshFavorites() async {
    if (!_isAuthenticated) return;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipes/favorites'),
        headers: getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] ?? data['favorites'] ?? data;
        _favoriteRecipes = (list as List)
            .map((item) => Recipe.fromMap(item['recipe'] ?? item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print('Refresh favorites error: $e');
    }
  }

  Future<bool> forgotPassword(String email) async => false;

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    // Your profile update code here
  }
} // ✅ This should be the ONLY closing brace for the class
