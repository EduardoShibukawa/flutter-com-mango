import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController
    with SessionManager
    implements SurveyResultPresenter {
  final SaveSurveyResult saveSurveyResult;
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _surveyResult = Rxn<SurveyResultViewModel>();

  Stream<SurveyResultViewModel> get surveyResultStream =>
      _surveyResult.stream.map((e) => e!);

  GetxSurveyResultPresenter({
    required this.saveSurveyResult,
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
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        isSessionExpired = true;
      else
        _surveyResult.addError(
            UIError.unexpected.description, StackTrace.current);
    }
  }

  Future<void> save({required String answer}) async {
    final surveyResult = await saveSurveyResult.save(answer: answer);

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
  }
}
