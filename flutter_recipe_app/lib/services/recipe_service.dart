// import 'dart:convert';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:flutter_recipe_app/services/auth_services.dart';
// import 'package:http/http.dart' as http;

// class RecipeService {
//   static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

//   // Search recipes by name
//   static Future<List<RecipeSummay>> searchRecipes(String query) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}search.php?s=$query'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<RecipeSummary> recipes = [];
//           for (var meal in data['meals']) {
//             recipes.add(RecipeSummary.Json(meal));
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error searching recipes: $e');
//       return [];
//     }
//   }

//   // Get recipe by ID
//   static Future<Recipe?> getRecipeById(String id) async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$id'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null && data['meals'].isNotEmpty) {
//           return Recipe.fromJson(data['meals'][0]);
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error getting recipe: $e');
//       return null;
//     }
//   }

//   // Get recipes by category
//   static Future<List<Recipe>> getRecipesByCategory(
//     String category,
//   ) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}filter.php?c=$category'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<RecipeSummary> recipes = [];
//           for (var meal in data['meals']) {
//             recipes.add(RecipeSummary.fromJson(meal));
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting recipes by category: $e');
//       return [];
//     }
//   }

//   // Get all categories
//   static Future<List<String>> getCategories() async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}list.php?c=list'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<String> categories = [];
//           for (var category in data['meals']) {
//             categories.add(category['strCategory']);
//           }
//           return categories;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting categories: $e');
//       return [];
//     }
//   }

//   // Get random recipe
//   static Future<Recipe?> getRandomRecipe() async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}random.php'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null && data['meals'].isNotEmpty) {
//           return Recipe.fromJson(data['meals'][0]);
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error getting random recipe: $e');
//       return null;
//     }
//   }import 'dart:convert';

// 2nd
// import 'dart:convert';

// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:http/http.dart' as http;

// class RecipeService {
//   static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

//   // Search recipes by name
//   static Future<List<Recipe>> searchRecipes(String query) async {
//     // Changed return type to List<Recipe>
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}search.php?s=$query'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<Recipe> recipes = []; // Changed to List<Recipe>
//           for (var meal in data['meals']) {
//             recipes.add(Recipe.fromJson(meal)); // Use Recipe.fromJson directly
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error searching recipes: $e');
//       return [];
//     }
//   }

//   // Get recipe by ID
//   static Future<Recipe?> getRecipeById(String id) async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$id'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null && data['meals'].isNotEmpty) {
//           return Recipe.fromJson(data['meals'][0]);
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error getting recipe: $e');
//       return null;
//     }
//   }

//   // Get recipes by category
//   static Future<List<Recipe>> getRecipesByCategory(String category) async {
//     // Changed return type to List<Recipe>
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}filter.php?c=$category'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<Recipe> recipes = []; // Changed to List<Recipe>

//           // For category filtering, we need to get full recipe details for each meal
//           // because the filter endpoint returns only basic info
//           for (var meal in data['meals']) {
//             // Get full recipe details using the meal ID
//             final fullRecipe = await getRecipeById(meal['idMeal']);
//             if (fullRecipe != null) {
//               recipes.add(fullRecipe);
//             }
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting recipes by category: $e');
//       return [];
//     }
//   }

//   // Alternative: Get only basic recipe info by category (faster but less data)
//   static Future<List<Recipe>> getRecipesByCategoryBasic(String category) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}filter.php?c=$category'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<Recipe> recipes = [];
//           for (var meal in data['meals']) {
//             // Create a basic Recipe object with available data
//             recipes.add(
//               Recipe(
//                 id: meal['idMeal'] ?? '',
//                 title: meal['strMeal'] ?? '',
//                 category: category,
//                 area: '', // Not available in filter response
//                 instructions: '', // Not available in filter response
//                 image: meal['strMealThumb'] ?? '',
//                 ingredients: [], // Not available in filter response
//                 measures: [], // Not available in filter response
//                 youtubeUrl: '', // Not available in filter response
//                 sourceUrl: '', // Not available in filter response
//               ),
//             );
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting recipes by category: $e');
//       return [];
//     }
//   }

//   // Get all categories
//   static Future<List<String>> getCategories() async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}list.php?c=list'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<String> categories = [];
//           for (var category in data['meals']) {
//             categories.add(category['strCategory']);
//           }
//           return categories;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting categories: $e');
//       return [];
//     }
//   }

//   // Get random recipe
//   static Future<Recipe?> getRandomRecipe() async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}random.php'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null && data['meals'].isNotEmpty) {
//           return Recipe.fromJson(data['meals'][0]);
//         }
//       }
//       return null;
//     } catch (e) {
//       print('Error getting random recipe: $e');
//       return null;
//     }
//   }

//   // Get recipes by area
//   static Future<List<Recipe>> getRecipesByArea(String area) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${_baseUrl}filter.php?a=$area'),
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<Recipe> recipes = [];
//           for (var meal in data['meals']) {
//             final fullRecipe = await getRecipeById(meal['idMeal']);
//             if (fullRecipe != null) {
//               recipes.add(fullRecipe);
//             }
//           }
//           return recipes;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting recipes by area: $e');
//       return [];
//     }
//   }

//   // Get all areas
//   static Future<List<String>> getAreas() async {
//     try {
//       final response = await http.get(Uri.parse('${_baseUrl}list.php?a=list'));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['meals'] != null) {
//           List<String> areas = [];
//           for (var area in data['meals']) {
//             areas.add(area['strArea']);
//           }
//           return areas;
//         }
//       }
//       return [];
//     } catch (e) {
//       print('Error getting areas: $e');
//       return [];
//     }
//   }
// }
// // }

import 'dart:async';
import 'dart:convert';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  static final http.Client _client = http.Client();

  // Add timeout and debugging to ALL API calls
  static Future<http.Response> _safeApiCall(
    Future<http.Response> apiCall,
  ) async {
    try {
      print('🚀 API call started: ${DateTime.now()}');
      final response = await apiCall.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('❌ API call timed out after 10 seconds');
          throw TimeoutException('Request timeout');
        },
      );
      print('✅ API call completed in: ${response.statusCode}');
      return response;
    } catch (e) {
      print('❌ API call failed: $e');
      rethrow;
    }
  }

  // Search recipes by name
  static Future<List<Recipe>> searchRecipes(String query) async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}search.php?s=$query')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<Recipe> recipes = [];
          for (var meal in data['meals']) {
            recipes.add(Recipe.fromJson(meal));
          }
          return recipes;
        }
      }
      return [];
    } catch (e) {
      print('Error searching recipes: $e');
      return [];
    }
  }

  // Get recipe by ID
  static Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}lookup.php?i=$id')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return Recipe.fromJson(data['meals'][0]);
        }
      }
      return null;
    } catch (e) {
      print('Error getting recipe: $e');
      return null;
    }
  }

  // FIXED: Get recipes by category - PARALLEL requests
  static Future<List<Recipe>> getRecipesByCategory(String category) async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}filter.php?c=$category')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          // Use Future.wait for PARALLEL execution instead of sequential
          final List<Future<Recipe?>> recipeFutures = data['meals']
              .map<Future<Recipe?>>((meal) => getRecipeById(meal['idMeal']))
              .toList();

          // All API calls happen in parallel
          final List<Recipe?> recipes = await Future.wait(recipeFutures);

          // Remove null values and return
          return recipes.whereType<Recipe>().toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting recipes by category: $e');
      return [];
    }
  }

  // Alternative: Get only basic recipe info (MUCH FASTER)
  static Future<List<Recipe>> getRecipesByCategoryBasic(String category) async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}filter.php?c=$category')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<Recipe> recipes = [];
          for (var meal in data['meals']) {
            recipes.add(
              Recipe(
                id: meal['idMeal'] ?? '',
                title: meal['strMeal'] ?? '',
                category: category,
                area: '',
                instructions: '',
                image: meal['strMealThumb'] ?? '',
                ingredients: [],
                measures: [],
                youtubeUrl: '',
                sourceUrl: '',
              ),
            );
          }
          return recipes;
        }
      }
      return [];
    } catch (e) {
      print('Error getting recipes by category: $e');
      return [];
    }
  }

  // FIXED: Get recipes by area - PARALLEL requests
  static Future<List<Recipe>> getRecipesByArea(String area) async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}filter.php?a=$area')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          // Use Future.wait for PARALLEL execution
          final List<Future<Recipe?>> recipeFutures = data['meals']
              .map<Future<Recipe?>>((meal) => getRecipeById(meal['idMeal']))
              .toList();

          final List<Recipe?> recipes = await Future.wait(recipeFutures);
          return recipes.whereType<Recipe>().toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting recipes by area: $e');
      return [];
    }
  }

  // Get all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}list.php?c=list')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<String> categories = [];
          for (var category in data['meals']) {
            categories.add(category['strCategory']);
          }
          return categories;
        }
      }
      return [];
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  // Get random recipe
  static Future<Recipe?> getRandomRecipe() async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}random.php')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return Recipe.fromJson(data['meals'][0]);
        }
      }
      return null;
    } catch (e) {
      print('Error getting random recipe: $e');
      return null;
    }
  }

  // Get all areas
  static Future<List<String>> getAreas() async {
    try {
      final response = await _safeApiCall(
        _client.get(Uri.parse('${_baseUrl}list.php?a=list')),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<String> areas = [];
          for (var area in data['meals']) {
            areas.add(area['strArea']);
          }
          return areas;
        }
      }
      return [];
    } catch (e) {
      print('Error getting areas: $e');
      return [];
    }
  }
}
