// import 'package:flutter/material.dart';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:flutter_recipe_app/services/auth_services.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_recipe_app/widget/recipe_card.dart';

// class FavoritesScreen extends StatefulWidget {
//   @override
//   _FavoritesScreenState createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final favorites = authService.favoriteRecipes;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Favorite Recipes'),
//         backgroundColor: Colors.orange,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () => authService.refreshFavorites(),
//           ),
//         ],
//       ),
//       body: authService.isAuthenticated
//           ? favorites.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.favorite_border,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'No favorites yet!',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Tap the heart icon on recipes to add them here',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: favorites.length,
//                     itemBuilder: (context, index) {
//                       return RecipeCard(recipe: favorites[index]);
//                     },
//                   )
//           : Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.login, size: 64, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text(
//                     'Please login to view favorites',
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:flutter_recipe_app/pages/login_page.dart'; // ✅ ADD THIS IMPORT
import 'package:flutter_recipe_app/widget/recipe_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // ✅ Check if user is authenticated
    if (!authService.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please login to view favorites',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    // User is authenticated - show favorites
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorite Recipes'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => authService.refreshFavorites(),
          ),
        ],
      ),
      body: authService.favoriteRecipes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the heart icon on recipes to add them here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: authService.favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = authService.favoriteRecipes[index];
                return RecipeCard(recipe: recipe);
              },
            ),
    );
  }
}
