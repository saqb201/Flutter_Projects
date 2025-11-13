class Recipe {
  final String id;
  final String title;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final List<String> ingredients;
  final List<String> measures;
  final String youtubeUrl;
  final String sourceUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
    required this.ingredients,
    required this.measures,
    required this.youtubeUrl,
    required this.sourceUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Extract ingredients and measures
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String ingredient = json['strIngredient$i'] ?? '';
      String measure = json['strMeasure$i'] ?? '';

      if (ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure);
      }
    }

    return Recipe(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      image: json['strMealThumb'] ?? '',
      ingredients: ingredients,
      measures: measures,
      youtubeUrl: json['strYoutube'] ?? '',
      sourceUrl: json['strSource'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': title,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': image,
      'strYoutube': youtubeUrl,
      'strSource': sourceUrl,
    };
  }
}

class RecipeSummary {
  final String id;
  final String title;
  final String category;
  final String area;
  final String image;

  RecipeSummary({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.image,
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) {
    return RecipeSummary(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      image: json['strMealThumb'] ?? '',
    );
  }
}
