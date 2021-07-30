import 'package:clean_flutter/ui/pages/pages.dart';

abstract class SurveysPresenter extends Presenter {
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String> get navigateToStream;
  Stream<bool> get isSessionExpiredStream;

  Future<void> loadData();

  void goToSurveyResult(String surveyId);
}
