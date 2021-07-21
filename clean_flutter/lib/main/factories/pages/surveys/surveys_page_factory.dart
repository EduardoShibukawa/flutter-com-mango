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
}

SurveysPage makeSurveyPage() {
  return SurveysPage(new Stub());
}
