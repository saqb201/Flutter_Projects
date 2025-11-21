// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:flutter_recipe_app/pages/recipe_detail_page.dart';
// import 'package:flutter_recipe_app/services/mongo_services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';

// class RecipeCard extends StatefulWidget {
//   final Recipe recipe;

//   const RecipeCard({Key? key, required this.recipe}) : super(key: key);

//   @override
//   _RecipeCardState createState() => _RecipeCardState();
// }

// class _RecipeCardState extends State<RecipeCard> {
//   bool _isFavorite = false;
//   bool _isProcessing = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkIfFavorite();
//   }

//   Future<void> _checkIfFavorite() async {
//     bool favorite = await MongoDBService.isFavorite(widget.recipe.id, context);
//     setState(() {
//       _isFavorite = favorite;
//     });
//   }

//   Future<void> _toggleFavorite() async {
//     if (_isProcessing) return;

//     setState(() {
//       _isProcessing = true;
//     });

//     bool success;
//     if (_isFavorite) {
//       success = await MongoDBService.removeFromFavorites(
//         widget.recipe.id,
//         context,
//       );
//     } else {
//       success = await MongoDBService.addToFavorites(widget.recipe, context);
//     }

//     if (success) {
//       setState(() {
//         _isFavorite = !_isFavorite;
//       });
//     }

//     setState(() {
//       _isProcessing = false;
//     });
//   }

//   void _showRecipeDetails() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecipeDetailPage(recipe: widget.recipe),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       child: InkWell(
//         onTap: _showRecipeDetails,
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CachedNetworkImage(
//                   imageUrl: widget.recipe.image,
//                   height: 150,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     height: 150,
//                     child: Shimmer.fromColors(
//                       baseColor: Colors.grey[300]!,
//                       highlightColor: Colors.grey[100]!,
//                       child: Container(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: _isProcessing
//                       ? CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             Colors.white,
//                           ),
//                         )
//                       : IconButton(
//                           icon: Icon(
//                             _isFavorite
//                                 ? Icons.favorite
//                                 : Icons.favorite_border,
//                             color: _isFavorite ? Colors.red : Colors.white,
//                           ),
//                           onPressed: _toggleFavorite,
//                         ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.recipe.title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.category, size: 14, color: Colors.grey),
//                       SizedBox(width: 4),
//                       Text(
//                         widget.recipe.category,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                       SizedBox(width: 12),
//                       Icon(Icons.location_on, size: 14, color: Colors.grey),
//                       SizedBox(width: 4),
//                       Text(
//                         widget.recipe.area,
//                         style: TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${widget.recipe.ingredients.length} ingredients',
//                     style: TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:flutter_recipe_app/pages/recipe_detail_page.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeCardState createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isFavorite = authService.isFavorite(widget.recipe.id);

    Future<void> _toggleFavorite() async {
      if (_isProcessing) return;

      setState(() {
        _isProcessing = true;
      });

      try {
        await authService.toggleFavorite(widget.recipe);
        // UI updates automatically via notifyListeners() in AuthService
      } catch (e) {
        print('Error toggling favorite: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }

    void _showRecipeDetails() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeDetailPage(recipe: widget.recipe),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: _showRecipeDetails,
        child: Column(
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.recipe.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _isProcessing
                      ? Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                            ),
                            onPressed: _toggleFavorite,
                          ),
                        ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.category, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        widget.recipe.category,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        widget.recipe.area,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${widget.recipe.ingredients.length} ingredients',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
