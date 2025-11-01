import 'package:flutter/material.dart';
import 'package:quiz_app/model/question_model.dart';


class QuizProvider with ChangeNotifier {
  final List<QuestionModel> _questions = [
    QuestionModel(
      question: "What is the capital of France?",
      options: ["Berlin", "Madrid", "Paris", "Lisbon"],
      correctIndex: 2,
    ),
    QuestionModel(
      question: "Flutter is developed by?",
      options: ["Apple", "Google", "Microsoft", "Amazon"],
      correctIndex: 1,
    ),
    QuestionModel(
      question: "Which language is used for Flutter?",
      options: ["Kotlin", "Swift", "Java", "Dart"],
      correctIndex: 3,
    ),
  ];

  int _currentIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _error = false;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get answered => _answered;
  bool get error => _error;

  QuestionModel get currentQuestion => _questions[_currentIndex];

  void answerQuestion(int selectedIndex) {
    if (_answered) return;

    _answered = true;
    if (selectedIndex == _questions[_currentIndex].correctIndex) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    try {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _answered = false;
        notifyListeners();
      } else {
        throw Exception("End of quiz");
      }
    } catch (e) {
      _error = true;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _error = false;
    notifyListeners();
  }
}
