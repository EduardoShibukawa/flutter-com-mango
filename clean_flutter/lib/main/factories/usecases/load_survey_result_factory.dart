import '../../../data/usecase/usecase.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../cache/cache.dart';
import '../factories.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) =>
    RemoteLoadSurveyResult(
      httpClient: makeAuthorizedHttpDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) =>
    LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
      remote: makeRemoteLoadSurveyResult(surveyId),
      local: makeLocalLoadSurveyResult(surveyId),
    );
