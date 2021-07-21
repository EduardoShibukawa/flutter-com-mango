import '../../../../ui/pages/pages.dart';

class Stub implements SurveysPresenter {
  @override
  Future<void> loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }
}

SurveysPage makeSurveyPage() {
  return SurveysPage(new Stub());
}
