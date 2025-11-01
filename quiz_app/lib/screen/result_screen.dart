import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/quiz_provider.dart';

import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context, listen: false);
    final score = quiz.score;
    final total = quiz.questions.length;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🎉 Quiz Completed!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Score: $score / $total",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  quiz.resetQuiz();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text("Play Again 🔁"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
