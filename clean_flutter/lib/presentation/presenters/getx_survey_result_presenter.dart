import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rxn<SurveyResultViewModel>();
  final _isSessionExpired = false.obs;

  Stream<SurveyResultViewModel> get surveyResultStream =>
      _surveyResult.stream.map((e) => e!);

  Stream<bool> get isSessionExpiredStream =>
      _isSessionExpired.stream.map((e) => e!);

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.surveyId,
  });

  Future<void> loadData() async {
    try {
      final surveyResult =
          await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((a) => SurveyAnswerViewModel(
                  image: a.image,
                  answer: a.answer,
                  isCurrentAnswer: a.isCurrentAnswer,
                  percent: '${a.percent}%',
                ))
            .toList(),
      );
    } on DomainError {
      _surveyResult.addError(
          UIError.unexpected.description, StackTrace.current);
    }
  }
}
