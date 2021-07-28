import 'survey_result.dart';

abstract class SurveyResultPresenter {
  Stream<SurveyResultViewModel> get surveyResultStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();
}