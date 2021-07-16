import '../factories.dart';
import '../../../data/usecase/usecase.dart';
import '../../../domain/usecases/usecases.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('login'),
  );
}
