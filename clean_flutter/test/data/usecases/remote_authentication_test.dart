import 'package:clean_flutter/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        });
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });

  test('Should call HttpClient with correct values', () async {
    // Act
    await sut.auth(params);

    // Assert
    verify(() => httpClient.request(url: url, method: 'post', body: {
          'email': params.email,
          'password': params.secret,
        }));
  });
  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    // Arrange
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.badRequest);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    // Arrange
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.notFound);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    // Arrange
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.serverError);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    // Arrange
    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenThrow(HttpError.unauthorized);

    // Act
    final future = sut.auth(params);

    // Assert
    expect(future, throwsA(DomainError.invalidCredentialsError));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    // Arrange
    final accessToken = faker.guid.guid();
    final name = faker.person.name();

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': name,
        });

    // Act
    final account = await sut.auth(params);

    // Assert
    expect(account.token, accessToken);
  });
}
