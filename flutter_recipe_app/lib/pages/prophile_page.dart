// import 'package:flutter/material.dart';
// import 'package:flutter_recipe_app/services/auth_services.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ProfilePage extends StatefulWidget {
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _bioController = TextEditingController();
//   bool _isEditing = false;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _loadUserData();
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // REPLACE entire initState with:
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadUserData();
//     });
//   }

//   void _loadUserData() {
//     final authService = Provider.of<AuthService>(context, listen: false);
//     final user = authService.currentUser;
//     if (user != null) {
//       _nameController.text = user['name'] ?? '';
//       _bioController.text = user['bio'] ?? '';
//     }
//   }

//   void _updateProfile() {
//     if (_formKey.currentState!.validate()) {
//       final authService = Provider.of<AuthService>(context, listen: false);
//       authService.updateProfile({
//         'name': _nameController.text.trim(),
//         'bio': _bioController.text.trim(),
//       });
//       setState(() => _isEditing = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Profile updated successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   String _formatDate(dynamic date) {
//     try {
//       if (date == null) return 'N/A';

//       DateTime dateTime;

//       if (date is String) {
//         dateTime = DateTime.parse(date);
//       } else if (date is DateTime) {
//         dateTime = date;
//       } else {
//         return 'N/A';
//       }

//       // Format: "Jan 15, 2024"
//       return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return months[month - 1];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final user = authService.currentUser;

//     if (user == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 200,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 'Profile',
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.orange, Colors.deepOrange],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverPadding(
//             padding: EdgeInsets.all(16),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(20),
//                     child: Column(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.orange[100],
//                           child: Icon(
//                             Icons.person,
//                             size: 50,
//                             color: Colors.orange,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         if (!_isEditing) ...[
//                           Text(
//                             user['name'],
//                             style: GoogleFonts.poppins(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             user['email'],
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           Text(
//                             user['bio'],
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           ElevatedButton(
//                             onPressed: () => setState(() => _isEditing = true),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: Text(
//                               'Edit Profile',
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ] else ...[
//                           Form(
//                             key: _formKey,
//                             child: Column(
//                               children: [
//                                 TextFormField(
//                                   controller: _nameController,
//                                   decoration: InputDecoration(
//                                     labelText: 'Name',
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter your name';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 SizedBox(height: 16),
//                                 TextFormField(
//                                   controller: _bioController,
//                                   maxLines: 3,
//                                   decoration: InputDecoration(
//                                     labelText: 'Bio',
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: OutlinedButton(
//                                         onPressed: () =>
//                                             setState(() => _isEditing = false),
//                                         style: OutlinedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                         ),
//                                         child: Text('Cancel'),
//                                       ),
//                                     ),
//                                     SizedBox(width: 12),
//                                     Expanded(
//                                       child: ElevatedButton(
//                                         onPressed: _updateProfile,
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.orange,
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(
//                                               12,
//                                             ),
//                                           ),
//                                         ),
//                                         child: Text(
//                                           'Save',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Statistics',
//                           style: GoogleFonts.poppins(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             _buildStatItem(
//                               Icons.favorite,
//                               'Favorites',
//                               authService.favoriteRecipes.length.toString(),
//                             ),
//                             _buildStatItem(
//                               Icons.calendar_today,
//                               'Member Since',
//                               _formatDate(user['joinDate']),
//                             ),
//                             _buildStatItem(Icons.star, 'Recipes Tried', '12'),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, color: Colors.orange, size: 30),
//         SizedBox(height: 8),
//         Text(
//           value,
//           style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           label,
//           style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/services/auth_services.dart';
import 'package:flutter_recipe_app/pages/login_page.dart'; // ✅ ADD THIS IMPORT
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _bioController.text = user['bio'] ?? '';
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.updateProfile({
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
      });
      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(dynamic date) {
    try {
      if (date == null) return 'N/A';

      DateTime dateTime;

      if (date is String) {
        dateTime = DateTime.parse(date);
      } else if (date is DateTime) {
        dateTime = date;
      } else {
        return 'N/A';
      }

      // Format: "Jan 15, 2024"
      return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    // ✅ ADDED: Check if user is authenticated
    if (!authService.isAuthenticated || user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile'), backgroundColor: Colors.orange),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please login to view profile',
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

    // User is authenticated - show profile
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Profile',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orange[100],
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 20),
                        if (!_isEditing) ...[
                          Text(
                            user['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user['email'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            user['bio'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => setState(() => _isEditing = true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Edit Profile',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ] else ...[
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                TextFormField(
                                  controller: _bioController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'Bio',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            setState(() => _isEditing = false),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text('Cancel'),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: _updateProfile,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Statistics',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              Icons.favorite,
                              'Favorites',
                              authService.favoriteRecipes.length.toString(),
                            ),
                            _buildStatItem(
                              Icons.calendar_today,
                              'Member Since',
                              _formatDate(user['joinDate']),
                            ),
                            _buildStatItem(Icons.star, 'Recipes Tried', '12'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.orange, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
