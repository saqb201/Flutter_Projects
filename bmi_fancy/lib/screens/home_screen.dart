import 'package:bmi_fancy/widget/bmi_card.dart';
import 'package:bmi_fancy/widget/bmi_slider.dart';
import 'package:bmi_fancy/widget/fancy_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double height = 170;
  double weight = 65;
  double? bmiResult;
  String? bmiCategory;

  void calculateBMI() {
    final double heightMeters = height / 100;
    final double bmi = weight / (heightMeters * heightMeters);

    String category;
    if (bmi < 18.5) {
      category = "Underweight";
    } else if (bmi < 25)
      category = "Normal";
    else if (bmi < 30)
      category = "Overweight";
    else
      category = "Obese";

    setState(() {
      bmiResult = bmi;
      bmiCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  "Fancy BMI Calculator",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                BMISlider(
                  value: height,
                  max: 250,
                  label: "Height (cm)",
                  onChanged: (val) => setState(() => height = val),
                ),
                const SizedBox(height: 20),
                BMISlider(
                  value: weight,
                  max: 200,
                  label: "Weight (kg)",
                  onChanged: (val) => setState(() => weight = val),
                ),
                const SizedBox(height: 30),
                FancyButton(text: "Calculate", onTap: calculateBMI),
                const SizedBox(height: 30),
                if (bmiResult != null && bmiCategory != null)
                  BMICard(bmi: bmiResult!, category: bmiCategory!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
