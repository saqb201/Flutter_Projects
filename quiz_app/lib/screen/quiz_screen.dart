import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/provider/quiz_provider.dart';
import 'package:quiz_app/screen/result_screen.dart';
import 'package:quiz_app/widget/quesion_card.dart';


class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quiz, _) {
        if (quiz.error) {
          return const Center(child: Text("Something went wrong 😢"));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Hero(tag: "title", child: Text("Quiz Time! 🎯")),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (quiz.currentIndex + 1) / quiz.questions.length,
                  color: Colors.deepPurple,
                  backgroundColor: Colors.deepPurple.shade100,
                ),
                const SizedBox(height: 20),
                Expanded(child: QuestionCard(question: quiz.currentQuestion)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (quiz.currentIndex == quiz.questions.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ResultScreen()),
                      );
                    } else {
                      quiz.nextQuestion();
                    }
                  },
                  child: Text(
                    quiz.currentIndex == quiz.questions.length - 1
                        ? "Finish 🎉"
                        : "Next ➡️",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
