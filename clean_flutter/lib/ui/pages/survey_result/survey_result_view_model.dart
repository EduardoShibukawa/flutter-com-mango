import 'package:equatable/equatable.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  List get props => ['surveyId', 'question', 'answers'];

  SurveyResultViewModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });
}

class SurveyAnswerViewModel extends Equatable {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final String percent;

  List get props => ['image', 'answer', 'isCurrentAnswer', 'percent'];

  SurveyAnswerViewModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });
}
