import 'package:clean_flutter/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_flutter/data/http/http_client.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  late HttpClient httpClient;
  late FetchSecureCacheStorage fetchSecureCacheStorage;
  late AuthorizeHttpClientDecorator sut;

  late String url;
  late String method;
  late Map body;
  late String token;
  late String httpResponse;

  void mockToken() {
    token = faker.guid.guid();
    when(() => fetchSecureCacheStorage.fetchSecure(any()))
        .thenAnswer((_) async => token);
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient,
    );

    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on headers', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => httpClient.request(
          url: url,
          method: method,
          body: body,
          headers: {'x-access-token': token},
        )).called(1);

    await sut.request(
      url: url,
      method: method,
      body: body,
      headers: {'any_header': 'any_value'},
    );

    verify(() => httpClient.request(
          url: url,
          method: method,
          body: body,
          headers: {
            'any_header': 'any_value',
            'x-access-token': token,
          },
        )).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });
}

class AuthorizeHttpClientDecorator<ResponseType> implements HttpClient {
  final HttpClient decoratee;
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.decoratee,
  });

  Future<ResponseType> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final String token = await fetchSecureCacheStorage.fetchSecure('token');
    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});

    return await decoratee.request(
        url: url, method: method, body: body, headers: authorizedHeaders);
  }
}
