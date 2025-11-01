import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BMISlider extends StatelessWidget {
  final double value;
  final String label;
  final ValueChanged<double> onChanged;
  final double max;

  const BMISlider({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$label: ${value.toStringAsFixed(1)}",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ).animate().fadeIn(duration: 600.ms),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: max.toInt(),
          activeColor: Colors.deepPurpleAccent,
          inactiveColor: Colors.white30,
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
