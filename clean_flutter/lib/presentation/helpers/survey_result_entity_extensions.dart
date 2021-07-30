import '../../domain/entities/entities.dart';
import '../../ui/pages/pages.dart';

extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() {
    return SurveyResultViewModel(
      surveyId: surveyId,
      question: question,
      answers: answers.map((a) => a.toViewModel()).toList(),
    );
  }
}

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() {
    return SurveyAnswerViewModel(
      image: image,
      answer: answer,
      isCurrentAnswer: isCurrentAnswer,
      percent: '$percent%',
    );
  }
}
