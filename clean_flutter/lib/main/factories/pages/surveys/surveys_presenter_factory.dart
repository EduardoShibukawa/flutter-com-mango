import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

SurveysPresenter makeGetxSurveysPresenter() {
  return GetxSurveysPresenter(
      loadSurveys: makeRemoteLoadSurveysWithLocalFallback());
}
