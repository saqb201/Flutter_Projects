import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedWeatherBackground extends StatelessWidget {
  final String condition;
  const AnimatedWeatherBackground({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    String asset;
    switch (condition.toLowerCase()) {
      case 'rain':
        asset = 'assets/animations/rain.json';
        break;
      case 'clouds':
        asset = 'assets/animations/cloudy.json';
        break;
      case 'clear':
        asset = 'assets/animations/sunny.json';
        break;
      default:
        asset = 'assets/animations/default.json';
    }

    return Lottie.asset(asset, fit: BoxFit.cover);
  }
}
