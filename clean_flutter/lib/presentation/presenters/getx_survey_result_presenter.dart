import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/helpers.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import '../helpers/helpers.dart';

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
    _showResultOnAction(
        () => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void> save({required String answer}) async {
    _showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void> _showResultOnAction(Future<SurveyResultEntity> action()) async {
    try {
      final surveyResult = await action();

      _surveyResult.value = surveyResult.toViewModel();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied)
        isSessionExpired = true;
      else
        _surveyResult.addError(
            UIError.unexpected.description, StackTrace.current);
    }
  }
}
