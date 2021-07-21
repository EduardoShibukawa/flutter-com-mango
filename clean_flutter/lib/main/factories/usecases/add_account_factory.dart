import '../factories.dart';
import '../../../data/usecase/usecase.dart';
import '../../../domain/usecases/usecases.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('signup'),
  );
}
