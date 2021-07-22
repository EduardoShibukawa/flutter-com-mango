import 'package:clean_flutter/ui/pages/pages.dart';

abstract class SurveysPresenter {
  Stream<List<SurveyViewModel>> get surveysStream;

  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}
