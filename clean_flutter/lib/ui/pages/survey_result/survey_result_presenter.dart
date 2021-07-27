import 'survey_result.dart';

abstract class SurveyResultPresenter {
  Stream<SurveyResultViewModel> get surveyResultStream;
  Future<void> loadData();
}
