import 'package:clean_flutter/domain/entities/entities.dart';

import '../http/http.dart';
import 'models.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<RemoteSurveyAnswerModel>(
              (a) => RemoteSurveyAnswerModel.fromJson(a))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map<SurveyAnswerEntity>((a) => a.toEntity()).toList(),
      );
}
