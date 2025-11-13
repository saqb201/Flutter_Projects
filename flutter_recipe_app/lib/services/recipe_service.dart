import 'dart:convert';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:http/http.dart' as http;


class RecipeService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Search recipes by name
  static Future<List<RecipeSummary>> searchRecipes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}search.php?s=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<RecipeSummary> recipes = [];
          for (var meal in data['meals']) {
            recipes.add(RecipeSummary.fromJson(meal));
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
      final response = await http.get(Uri.parse('${_baseUrl}lookup.php?i=$id'));

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

  // Get recipes by category
  static Future<List<RecipeSummary>> getRecipesByCategory(
    String category,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          List<RecipeSummary> recipes = [];
          for (var meal in data['meals']) {
            recipes.add(RecipeSummary.fromJson(meal));
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

  // Get all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}list.php?c=list'));

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
      final response = await http.get(Uri.parse('${_baseUrl}random.php'));

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
}
