import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../factories.dart';

HttpClient makeAuthorizedHttpDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
    );
