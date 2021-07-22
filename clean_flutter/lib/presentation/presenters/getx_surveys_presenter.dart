import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.map((e) => e!);
  Stream<List<SurveyViewModel>> get surveysStream =>
      _surveys.stream.map((e) => e!);

  GetxSurveysPresenter(this.loadSurveys);

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
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
    } on DomainError {
      _surveys.addError(UIError.unexpected.description, StackTrace.current);
    } finally {
      _isLoading.value = false;
    }
  }
}
