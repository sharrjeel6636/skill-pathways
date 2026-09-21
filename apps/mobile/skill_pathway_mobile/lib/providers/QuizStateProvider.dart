import 'package:flutter/material.dart';
import '../quiz_model.dart';

class QuizStateProvider extends ChangeNotifier {
  QuizResult? _completedResult = QuizState.completedResult;
  String? _fieldOfInterest = QuizState.fieldOfInterest;

  QuizResult? get completedResult => _completedResult;
  String? get fieldOfInterest => _fieldOfInterest;

  void updateQuizResult(QuizResult result) {
    _completedResult = result;
    QuizState.completedResult = result; // Keep in sync
    notifyListeners();
  }

  void updateFieldOfInterest(String field) {
    _fieldOfInterest = field;
    QuizState.fieldOfInterest = field; // Keep in sync
    notifyListeners();
  }
}
