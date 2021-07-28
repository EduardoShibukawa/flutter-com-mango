import '../../domain/entities/entities.dart';
import '../http/http.dart';

class LocalSurveyResultModel {
  final String surveyId;
  final String question;
  final List<LocalSurveyAnswerModel> answers;

  LocalSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory LocalSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    return LocalSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers']
          .map<LocalSurveyAnswerModel>(
              (a) => LocalSurveyAnswerModel.fromJson(a))
          .toList(),
    );
  }

  factory LocalSurveyResultModel.fromEntity(SurveyResultEntity survey) {
    return LocalSurveyResultModel(
      surveyId: survey.surveyId,
      question: survey.question,
      answers: survey.answers
          .map<LocalSurveyAnswerModel>(
              (a) => LocalSurveyAnswerModel.fromEntity(a))
          .toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map<SurveyAnswerEntity>((a) => a.toEntity()).toList(),
      );

  Map toJson() => {
        'surveyId': surveyId,
        'question': question,
        'answers': answers.map((a) => a.toJson()).toList(),
      };
}

class LocalSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAnswer;
  final int percent;

  LocalSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent,
  });

  factory LocalSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['answer', 'isCurrentAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return LocalSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAnswer: json['isCurrentAnswer'].toLowerCase() == 'true',
      percent: int.parse(json['percent']),
    );
  }

  factory LocalSurveyAnswerModel.fromEntity(SurveyAnswerEntity answer) {
    return LocalSurveyAnswerModel(
      image: answer.image,
      answer: answer.answer,
      isCurrentAnswer: answer.isCurrentAnswer,
      percent: answer.percent,
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAnswer,
        percent: percent,
      );

  Map toJson() => {
        'image': image,
        'answer': answer,
        'isCurrentAnswer': isCurrentAnswer.toString(),
        'percent': percent.toString(),
      };
}
