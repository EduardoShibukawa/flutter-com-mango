import 'package:clean_flutter/domain/entities/entities.dart';

class SurveyResultEntity {
  final String surveyId;
  final String question;
  final bool didAnswer;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    required this.surveyId,
    required this.question,
    required this.didAnswer,
    required this.answers,
  });
}
