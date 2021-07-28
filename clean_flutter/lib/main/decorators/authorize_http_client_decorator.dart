import 'package:http/http.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final HttpClient decoratee;
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
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
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) rethrow;

      await deleteSecureCacheStorage.deleteSecure('token');
      throw HttpError.forbidden;
    }
  }
}
