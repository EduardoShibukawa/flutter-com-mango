import '../../../data/usecase/usecase.dart';
import '../../composites/remote_local_surveys_with_callback.dart';
import '../cache/local_storage_adapter_factory.dart';
import '../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizedHttpDecorator(),
    url: makeApiUrl('surveys'),
  );
}

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

RemoteLoadSurveysWithLocalFallback makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(
    remote: makeRemoteLoadSurveys(),
    local: makeLocalLoadSurveys(),
  );
}
