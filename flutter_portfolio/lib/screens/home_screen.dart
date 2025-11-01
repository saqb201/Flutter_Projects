import 'package:flutter/material.dart';
import 'package:flutter_portfolio/model/project_model.dart';
import 'package:flutter_portfolio/widget/animated_header.dart';
import 'package:flutter_portfolio/widget/projecr_card.dart';
import 'package:flutter_portfolio/widget/social_icon_button.dart';

class HomeScreen extends StatelessWidget {
  final List<Project> projects = [
    Project(
      name: 'Flutter Chat App',
      description: 'A real-time chat app using Supabase and phone auth.',
      imageUrl: 'https://via.placeholder.com/400',
      githubUrl: 'https://github.com/username/flutter-chat-app',
      liveDemoUrl: 'https://flutter-chat-app.web.app',
    ),
    Project(
      name: 'E-commerce App',
      description: 'Full-featured e-commerce app using Flutter.',
      imageUrl: 'https://via.placeholder.com/400',
      githubUrl: 'https://github.com/username/flutter-ecommerce-app',
      liveDemoUrl: 'https://flutter-ecommerce.web.app',
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            AnimatedHeader(text: 'Hi, I am Syed M Saqib'),
            SizedBox(height: 10),
            Text(
              'Flutter Developer | Mobile & Web',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            AnimatedHeader(text: 'My Projects'),
            ...projects.map((p) => ProjectCard(project: p)),
            SizedBox(height: 30),
            AnimatedHeader(text: 'Contact Me'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIconButton(
                  iconPath: 'assets/icons/github.png',
                  url: 'https://github.com/saqb201',
                ),
                SocialIconButton(
                  iconPath: 'assets/icons/facebook.png',
                  url: 'https://facebook.com/',
                ),
                SocialIconButton(
                  iconPath: 'assets/icons/whatsapp.png',
                  url: 'https://web.whatsapp.com/',
                ),
                SocialIconButton(
                  iconPath: 'assets/icons/instagram.png',
                  url: 'https://instagram.com/',
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('© 2025 Syed Saqib', style: TextStyle(fontSize: 14)),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
