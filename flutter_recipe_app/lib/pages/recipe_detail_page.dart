// import 'package:flutter/material.dart';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:flutter_recipe_app/services/auth_services.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/recipe_service.dart';


// class RecipeDetailPage extends StatefulWidget {
//   final String recipeId;

//   const RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

//   @override
//   State<RecipeDetailPage> createState() => _RecipeDetailPageState();
// }

// class _RecipeDetailPageState extends State<RecipeDetailPage> {
//   Recipe? _recipe;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadRecipe();
//   }

//   Future<void> _loadRecipe() async {
//     try {
//       final recipe = await RecipeService.getRecipeById(widget.recipeId);
//       setState(() {
//         _recipe = recipe;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading recipe: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final isFavorite = _recipe != null
//         ? authService.isFavorite(_recipe!.id)
//         : false;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recipe Details'),
//         actions: [
//           if (_recipe != null)
//             IconButton(
//               icon: Icon(
//                 isFavorite ? Icons.favorite : Icons.favorite_border,
//                 color: isFavorite ? Colors.red : Colors.white,
//               ),
//               onPressed: () {
//                 if (_recipe != null) {
//                   authService.toggleFavorite(
//                     RecipeSummary(
//                       id: _recipe!.id,
//                       title: _recipe!.title,
//                       category: _recipe!.category,
//                       area: _recipe!.area,
//                       image: _recipe!.image,
//                     ),
//                   );
//                 }
//               },
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _recipe == null
//           ? Center(child: Text('Recipe not found'))
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Recipe Image
//                   Container(
//                     height: 250,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       image: DecorationImage(
//                         image: NetworkImage(_recipe!.image),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),

//                   // Recipe Title and Info
//                   Text(
//                     _recipe!.title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Chip(
//                         label: Text(_recipe!.category),
//                         backgroundColor: Colors.orange[100],
//                       ),
//                       SizedBox(width: 8),
//                       Chip(
//                         label: Text(_recipe!.area),
//                         backgroundColor: Colors.blue[100],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 24),

//                   // Ingredients
//                   Text(
//                     'Ingredients',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   ..._recipe!.ingredients.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final ingredient = entry.value;
//                     final measure = _recipe!.measures[index];

//                     return ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: Colors.orange,
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       title: Text(ingredient),
//                       subtitle: Text(measure),
//                     );
//                   }).toList(),
//                   SizedBox(height: 24),

//                   // Instructions
//                   Text(
//                     'Instructions',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     _recipe!.instructions,
//                     style: GoogleFonts.poppins(fontSize: 16),
//                   ),
//                   SizedBox(height: 24),

//                   // YouTube Link
//                   if (_recipe!.youtubeUrl.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Video Tutorial',
//                           style: GoogleFonts.poppins(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         GestureDetector(
//                           onTap: () {
//                             // You can use url_launcher package to open the URL
//                           },
//                           child: Container(
//                             padding: EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(Icons.play_arrow, color: Colors.white),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Watch on YouTube',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe; // Change from recipeId to full Recipe object

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool _isFavorite = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfFavorite();
  // }

  @override
  void initState() {
    super.initState();
    // REPLACE entire initState with:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfFavorite();
    });
  }

  Future<void> _checkIfFavorite() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    bool favorite = authService.isFavorite(widget.recipe.id);
    setState(() {
      _isFavorite = favorite;
    });
  }

  void _toggleFavorite() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.toggleFavorite(widget.recipe);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(widget.recipe.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Recipe Title and Info
            Text(
              widget.recipe.title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(widget.recipe.category),
                  backgroundColor: Colors.orange[100],
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(widget.recipe.area),
                  backgroundColor: Colors.blue[100],
                ),
              ],
            ),
            SizedBox(height: 24),

            // Ingredients
            Text(
              'Ingredients',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ...widget.recipe.ingredients.asMap().entries.map((entry) {
              final index = entry.key;
              final ingredient = entry.value;
              final measure = widget.recipe.measures[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(ingredient),
                subtitle: Text(measure),
              );
            }).toList(),
            SizedBox(height: 24),

            // Instructions
            Text(
              'Instructions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.recipe.instructions,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(height: 24),

            // YouTube Link
            if (widget.recipe.youtubeUrl.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Video Tutorial',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // You can use url_launcher package to open the URL
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Watch on YouTube',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
