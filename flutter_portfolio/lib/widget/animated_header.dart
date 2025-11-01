import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedHeader extends StatelessWidget {
  final String text;
  const AnimatedHeader({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }
}
