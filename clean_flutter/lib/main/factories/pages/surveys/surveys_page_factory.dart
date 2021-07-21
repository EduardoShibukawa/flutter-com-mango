import '../../../../ui/pages/pages.dart';

class Stub implements SurveysPresenter {
  @override
  Future<void> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  // TODO: implement isLoadingStream
  Stream<bool> get isLoadingStream => throw UnimplementedError();

  @override
  // TODO: implement loadSurveyStream
  Stream<List<SurveyViewModel>> get loadSurveyStream =>
      throw UnimplementedError();
}

SurveysPage makeSurveyPage() {
  return SurveysPage(new Stub());
}
