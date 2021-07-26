import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

SurveysPresenter makeSGetxSurveysPresenter() {
  return GetxSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveysWithLocalFallback());
}
