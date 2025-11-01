import 'package:flutter/material.dart';
import 'package:quiz_app/model/question_model.dart';
import 'package:quiz_app/provider/quiz_provider.dart';
import 'package:provider/provider.dart';

import 'animated_button.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<QuizProvider>(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              question.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final isCorrect = question.correctIndex == index;
              final isSelected =
                  quiz.answered && index == question.correctIndex;
              return AnimatedButton(
                text: question.options[index],
                color: quiz.answered
                    ? (isCorrect ? Colors.greenAccent : Colors.redAccent)
                    : Colors.deepPurple.shade200,
                onTap: () => quiz.answerQuestion(index),
                disabled: quiz.answered,
              );
            }),
          ],
        ),
      ),
    );
  }
}
