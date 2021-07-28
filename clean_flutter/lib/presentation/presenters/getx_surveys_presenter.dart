import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _surveys = Rx<List<SurveyViewModel>>([]);
  final _navigateTo = RxnString();
  final _isSessionExpired = false.obs;

  Stream<List<SurveyViewModel>> get surveysStream =>
      _surveys.stream.map((e) => e!);
  Stream<String> get navigateToStream => _navigateTo.map((s) => s!);
  Stream<bool> get isSessionExpiredStream =>
      _isSessionExpired.stream.map((e) => e!);

  GetxSurveysPresenter({required this.loadSurveys});

  Future<void> loadData() async {
    try {
      final surveys = await loadSurveys.load();
      _surveys.value = surveys
          .map(
            (s) => SurveyViewModel(
              id: s.id,
              question: s.question,
              date: Intl.withLocale(
                R.locale.toString(),
                () => DateFormat('dd MMM yyyy').format(s.dateTime),
              ),
              didAnswer: s.didAnswer,
            ),
          )
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        _isSessionExpired.value = true;
      else
        _surveys.addError(UIError.unexpected.description, StackTrace.current);
    }
  }

  void goToSurveyResult(String surveyId) {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}
