import '../factories.dart';
import '../../../data/usecase/usecase.dart';
import '../../../domain/usecases/usecases.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizedHttpDecorator(),
    url: makeApiUrl('surveys'),
  );
}
