// Continue from where it left off in home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_recipe_app/pages/fav_page.dart';
import 'package:flutter_recipe_app/pages/prophile_page.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final List<Widget> _pages = [
    RecipeFeedPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: Icon(Icons.logout, color: Colors.orange),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthService>(context, listen: false).logout();
            },
            child: Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class RecipeFeedPage extends StatelessWidget {
  final List<Map<String, dynamic>> _recipes = [
    {
      'id': '1',
      'title': 'Spaghetti Carbonara',
      'description': 'Creamy Italian pasta with eggs, cheese, and pancetta',
      'image':
          'https://as1.ftcdn.net/jpg/01/09/75/90/1000_F_109759077_SVp62TBuHkSn3UsGW4dBOm9R0ALVetYw.jpg',
      'cookingTime': 25,
      'difficulty': 'Medium',
      'rating': 4.8,
    },
    {
      'id': '2',
      'title': 'Chicken Tikka Masala',
      'description': 'Tender chicken in creamy spiced tomato sauce',
      'image':
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      'cookingTime': 40,
      'difficulty': 'Medium',
      'rating': 4.6,
    },
    {
      'id': '3',
      'title': 'Avocado Toast',
      'description': 'Healthy breakfast with smashed avocado on toast',
      'image':
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      'cookingTime': 10,
      'difficulty': 'Easy',
      'rating': 4.3,
    },
    {
      'id': '4',
      'title': 'Beef Burger',
      'description': 'Juicy beef patty with fresh vegetables and sauce',
      'image':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      'cookingTime': 20,
      'difficulty': 'Easy',
      'rating': 4.7,
    },
    {
      'id': '5',
      'title': 'Chocolate Cake',
      'description': 'Rich and moist chocolate dessert',
      'image':
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
      'cookingTime': 60,
      'difficulty': 'Hard',
      'rating': 4.9,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              'https://images.unsplash.com/photo-1495521821757-a1efb6729352?ixlib=rb-4.0.3&auto=format&fit=crop&w=1926&q=80',
              fit: BoxFit.cover,
            ),
          ),
        ),
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
              return _buildRecipeCard(context, _recipes[index]);
            }, childCount: _recipes.length),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    final authService = Provider.of<AuthService>(context);
    final isFavorite = authService.isFavorite(recipe['id']);

    return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Stack(
                    children: [
                      Image.network(
                        recipe['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
                      recipe['title'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      recipe['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          '${recipe['cookingTime']} mins',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(recipe['difficulty']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            recipe['difficulty'],
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          recipe['rating'].toString(),
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fade(duration: 500.ms)
        .scale(begin: Offset(0.8, 0.8), duration: 500.ms);
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
