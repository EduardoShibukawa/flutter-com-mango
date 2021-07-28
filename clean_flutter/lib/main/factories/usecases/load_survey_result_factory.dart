import '../../../data/usecase/usecase.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveysResult(
    httpClient: makeAuthorizedHttpDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}
