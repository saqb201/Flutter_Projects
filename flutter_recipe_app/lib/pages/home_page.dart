// import 'package:flutter/material.dart';
// import 'package:flutter_recipe_app/Model/recipe_model.dart';
// import 'package:flutter_recipe_app/services/auth_services.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../services/recipe_service.dart';
// import 'fav_page.dart';
// import 'prophile_page.dart';
// import 'recipe_detail_page.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);

//     // Define pages inside build method to access context
//     final List<Widget> _pages = [
//       RecipeFeedPage(),
//       FavoritesScreen(),
//       ProfilePage(),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Recipe App',
//           style: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             color: Colors.orange,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           if (authService.isAuthenticated) // Only show if logged in
//             IconButton(
//               icon: Icon(Icons.logout, color: Colors.orange),
//               onPressed: () {
//                 _showLogoutDialog(context);
//               },
//             ),
//         ],
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() => _currentIndex = index);
//         },
//         selectedItemColor: Colors.orange,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     final authService = Provider.of<AuthService>(context, listen: false);

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Logout'),
//         content: Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               authService.logout();
//               // If you have a login page, navigate there:
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//             child: Text('Logout', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class RecipeFeedPage extends StatefulWidget {
//   @override
//   State<RecipeFeedPage> createState() => _RecipeFeedPageState();
// }

// class _RecipeFeedPageState extends State<RecipeFeedPage> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Recipe> _recipes = [];
//   List<Recipe> _filteredRecipes = [];
//   List<String> _categories = [];
//   String _selectedCategory = 'All';
//   bool _isLoading = true;
//   bool _isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     try {
//       // Load categories
//       _categories = await RecipeService.getCategories();
//       _categories.insert(0, 'All');

//       // Load initial recipes - use BASIC version for speed
//       await _loadRecipesByCategory('Beef');
//     } catch (e) {
//       print('Error loading data: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // FIXED: Use parallel requests and basic data for speed
//   Future<void> _loadRecipesByCategory(String category) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       if (category == 'All') {
//         // Load random recipes in PARALLEL
//         final List<Future<Recipe?>> randomFutures = List.generate(
//           5,
//           (index) => RecipeService.getRandomRecipe(),
//         );

//         final List<Recipe?> recipes = await Future.wait(randomFutures);
//         _recipes = recipes.whereType<Recipe>().toList();
//       } else {
//         // Use BASIC version for MUCH faster loading
//         _recipes = await RecipeService.getRecipesByCategoryBasic(category);

//         // If you need full details, load them in background
//         _loadFullRecipeDetailsInBackground();
//       }
//     } catch (e) {
//       print('Error loading recipes: $e');
//       _recipes = [];
//     }

//     setState(() {
//       _filteredRecipes = _recipes;
//       _isLoading = false;
//     });
//   }

//   // Load full details in background without blocking UI
//   void _loadFullRecipeDetailsInBackground() async {
//     try {
//       final fullRecipes = await RecipeService.getRecipesByCategory(
//         _selectedCategory,
//       );
//       if (mounted) {
//         setState(() {
//           _recipes = fullRecipes;
//           _filteredRecipes = fullRecipes;
//         });
//       }
//     } catch (e) {
//       print('Background full details loading failed: $e');
//     }
//   }

//   Future<void> _searchRecipes(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _filteredRecipes = _recipes;
//         _isSearching = false;
//       });
//       return;
//     }

//     setState(() {
//       _isSearching = true;
//     });

//     try {
//       final results = await RecipeService.searchRecipes(query);
//       setState(() {
//         _filteredRecipes = results;
//         _isSearching = false;
//       });
//     } catch (e) {
//       print('Search error: $e');
//       setState(() {
//         _isSearching = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Search Bar
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: 'Search recipes...',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               suffixIcon: _searchController.text.isNotEmpty
//                   ? IconButton(
//                       icon: Icon(Icons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         _searchRecipes('');
//                       },
//                     )
//                   : null,
//             ),
//             onChanged: (value) {
//               _searchRecipes(value);
//             },
//           ),
//         ),

//         // Category Filter
//         Container(
//           height: 50,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _categories.length,
//             itemBuilder: (context, index) {
//               final category = _categories[index];
//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8),
//                 child: FilterChip(
//                   label: Text(category),
//                   selected: _selectedCategory == category,
//                   onSelected: (selected) {
//                     setState(() {
//                       _selectedCategory = category;
//                     });
//                     _loadRecipesByCategory(category);
//                   },
//                   selectedColor: Colors.orange,
//                   checkmarkColor: Colors.white,
//                 ),
//               );
//             },
//           ),
//         ),

//         // Loading indicator
//         if (_isLoading)
//           LinearProgressIndicator(
//             backgroundColor: Colors.grey[200],
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//           ),

//         // Recipes Grid
//         Expanded(
//           child: _isLoading && _filteredRecipes.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(color: Colors.orange),
//                       SizedBox(height: 16),
//                       Text(
//                         'Loading delicious recipes...',
//                         style: GoogleFonts.poppins(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 )
//               : _isSearching
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircularProgressIndicator(color: Colors.orange),
//                       SizedBox(height: 16),
//                       Text(
//                         'Searching...',
//                         style: GoogleFonts.poppins(color: Colors.grey[600]),
//                       ),
//                     ],
//                   ),
//                 )
//               : _filteredRecipes.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search_off, size: 64, color: Colors.grey),
//                       SizedBox(height: 16),
//                       Text(
//                         'No recipes found',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : CustomScrollView(
//                   slivers: [
//                     SliverPadding(
//                       padding: EdgeInsets.all(16),
//                       sliver: SliverGrid(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                           childAspectRatio: 0.8,
//                         ),
//                         delegate: SliverChildBuilderDelegate((context, index) {
//                           return _buildRecipeCard(
//                             context,
//                             _filteredRecipes[index],
//                           );
//                         }, childCount: _filteredRecipes.length),
//                       ),
//                     ),
//                   ],
//                 ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
//     final authService = Provider.of<AuthService>(context);
//     final isFavorite = authService.isFavorite(recipe.id);

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => RecipeDetailPage(recipe: recipe),
//           ),
//         );
//       },
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//                 child: Stack(
//                   children: [
//                     Image.network(
//                       recipe.image,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               value: loadingProgress.expectedTotalBytes != null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                   : null,
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Icon(
//                             Icons.fastfood,
//                             color: Colors.grey[400],
//                             size: 40,
//                           ),
//                         );
//                       },
//                     ),
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             isFavorite ? Icons.favorite : Icons.favorite_border,
//                             color: isFavorite ? Colors.red : Colors.grey,
//                             size: 20,
//                           ),
//                           onPressed: () {
//                             authService.toggleFavorite(recipe);
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     recipe.title,
//                     style: GoogleFonts.poppins(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     recipe.category,
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     recipe.area,
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: Colors.orange,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${recipe.ingredients.length} ingredients',
//                     style: GoogleFonts.poppins(
//                       fontSize: 10,
//                       color: Colors.grey[500],
//                     ),
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

import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/Model/recipe_model.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:flutter_recipe_app/pages/login_page.dart'; // ✅ ADD THIS IMPORT
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/recipe_service.dart';
import 'fav_page.dart';
import 'prophile_page.dart';
import 'recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // FIXED: Pages are created once and preserved
  final List<Widget> _pages = [
    RecipeFeedPage(),
    FavoritesScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // ✅ ADDED: Double-check authentication state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!authService.isAuthenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
      }
    });

    // ✅ ADDED: If not authenticated, show loading
    if (!authService.isAuthenticated) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipe App',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (authService.isAuthenticated) // Only show if logged in
            IconButton(
              icon: Icon(Icons.logout, color: Colors.orange),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
        ],
      ),
      body: IndexedStack(
        // FIXED: Preserves state when switching tabs
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authService.logout();

              // ✅ FIXED: Navigate to login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class RecipeFeedPage extends StatefulWidget {
  @override
  State<RecipeFeedPage> createState() => _RecipeFeedPageState();
}

class _RecipeFeedPageState extends State<RecipeFeedPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load categories
      _categories = await RecipeService.getCategories();
      _categories.insert(0, 'All');

      // Load initial recipes - use BASIC version for speed
      await _loadRecipesByCategory('Beef');
    } catch (e) {
      print('Error loading data: $e');
      // FIXED: Show error state
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRecipesByCategory(String category) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _selectedCategory = category;
    });

    try {
      if (category == 'All') {
        // Load random recipes in PARALLEL
        final List<Future<Recipe?>> randomFutures = List.generate(
          8, // Increased for better UX
          (index) => RecipeService.getRandomRecipe(),
        );

        final List<Recipe?> recipes = await Future.wait(randomFutures);
        _recipes = recipes.whereType<Recipe>().toList();
      } else {
        // Use basic version for faster loading
        _recipes = await RecipeService.getRecipesByCategoryBasic(category);
      }

      // FIXED: Update filtered recipes
      _filteredRecipes = _recipes;
    } catch (e) {
      print('Error loading recipes: $e');
      _recipes = [];
      _filteredRecipes = [];

      // FIXED: Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load recipes. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchRecipes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredRecipes = _recipes;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await RecipeService.searchRecipes(query);
      setState(() {
        _filteredRecipes = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _isSearching = false;
        _filteredRecipes = []; // Clear results on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search recipes...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchRecipes('');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              _searchRecipes(value);
            },
          ),
        ),

        // Category Filter
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    _loadRecipesByCategory(category);
                  },
                  selectedColor: Colors.orange,
                  checkmarkColor: Colors.white,
                ),
              );
            },
          ),
        ),

        // Loading indicator
        if (_isLoading)
          LinearProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),

        // Recipes Grid
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_isLoading && _filteredRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Loading delicious recipes...',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_filteredRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No recipes found for "${_searchController.text}"'
                  : 'No recipes available',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildRecipeCard(context, _filteredRecipes[index]);
            }, childCount: _filteredRecipes.length),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    final authService = Provider.of<AuthService>(context);
    final isFavorite = authService.isFavorite(recipe.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Image.network(
                      recipe.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.fastfood,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () {
                            authService.toggleFavorite(recipe);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    recipe.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (recipe.area.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      recipe.area,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  SizedBox(height: 4),
                  Text(
                    '${recipe.ingredients.length} ingredients',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
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
