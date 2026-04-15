import 'question.dart';

class QuizBrain {
  int _questionNumber = 0;

  final List<Question> _questionsBank = [
    Question(questionText: 'The earth is round?', questionAnswer: true),
    Question(questionText: 'Cats can fly.', questionAnswer: false),
    Question(
      questionText: 'There are 30 days in February?',
      questionAnswer: false,
    ),
  ];
  bool isFinished() {
    if (_questionNumber >= _questionsBank.length - 1) {
      return true;
    } else {
      return false;
    }
  }

  void reset() {
    _questionNumber = 0;
  }

  String getQuestionText() {
    return _questionsBank[_questionNumber].questionText;
  }

  bool getQuestionAnswer() {
    return _questionsBank[_questionNumber].questionAnswer;
  }

  int getTotalQuestions() {
    return _questionsBank.length;
  }

  void nextQuestion() {
    if (_questionNumber < _questionsBank.length - 1) {
      _questionNumber++;
    } else {
      _questionNumber = 0;
    }
  }
}
