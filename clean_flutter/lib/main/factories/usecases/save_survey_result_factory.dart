import '../../../data/usecase/usecase.dart';
import '../factories.dart';

RemoteSaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) =>
    RemoteSaveSurveyResult(
      httpClient: makeAuthorizedHttpDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );
