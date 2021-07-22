import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final HttpClient decoratee;
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.decoratee,
  });

  Future<dynamic> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    late String token;

    try {
      token = await fetchSecureCacheStorage.fetchSecure('token');
    } catch (_) {
      throw HttpError.forbidden;
    }

    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});

    return Future.value(
      await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      ),
    );
  }
}
