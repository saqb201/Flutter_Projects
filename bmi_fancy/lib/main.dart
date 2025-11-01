import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fancy BMI Calculator",
      theme: ThemeData(fontFamily: "Poppins"),
      home: const HomeScreen(),
    );
  }
}
