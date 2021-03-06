import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/domain/helpers/domain_error.dart';

import '../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  When mockRequest() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAuthentication();
    mockHttpData(FakeAccountFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    // Act
    await sut.auth(params: params);

    // Assert
    verify(() => httpClient.request(url: url, method: 'post', body: {
          'email': params.email,
          'password': params.secret,
        }));
  });
  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    // Arrange
    mockHttpError(HttpError.badRequest);

    // Act
    final future = sut.auth(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    // Arrange
    mockHttpError(HttpError.notFound);

    // Act
    final future = sut.auth(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    // Arrange
    mockHttpError(HttpError.serverError);

    // Act
    final future = sut.auth(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    // Arrange
    mockHttpError(HttpError.unauthorized);

    // Act
    final future = sut.auth(params: params);

    // Assert
    expect(future, throwsA(DomainError.invalidCredentialsError));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    // Act
    final account = await sut.auth(params: params);

    // Assert
    expect(account.token, apiResult['accessToken']);
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    // Arrange
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    // Act
    final future = sut.auth(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
