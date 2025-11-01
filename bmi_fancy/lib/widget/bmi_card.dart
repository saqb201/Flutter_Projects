import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BMICard extends StatelessWidget {
  final double bmi;
  final String category;

  const BMICard({super.key, required this.bmi, required this.category});

  Color _getColor() {
    if (bmi < 18.5) return Colors.blueAccent;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: _getColor().withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "BMI: ${bmi.toStringAsFixed(1)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: 800.ms),
          const SizedBox(height: 10),
          Text(
            category,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 1000.ms),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scaleXY(begin: 0.8, end: 1);
  }
}
