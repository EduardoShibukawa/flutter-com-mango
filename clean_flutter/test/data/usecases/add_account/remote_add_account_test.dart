import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClient httpClient;
  late String url;
  late AddAccountParams params;

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  When mockRequest() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
      name: faker.person.name(),
      email: faker.internet.email(),
      password: faker.internet.password(),
      passwordConfirmation: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    // Act
    await sut.add(params: params);

    // Assert
    verify(() => httpClient.request(url: url, method: 'post', body: {
          'name': params.name,
          'email': params.email,
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
        }));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    // Arrange
    mockHttpError(HttpError.badRequest);

    // Act
    final future = sut.add(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    // Arrange
    mockHttpError(HttpError.notFound);

    // Act
    final future = sut.add(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    // Arrange
    mockHttpError(HttpError.serverError);

    // Act
    final future = sut.add(params: params);

    // Assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 403',
      () async {
    // Arrange
    mockHttpError(HttpError.forbidden);

    // Act
    final future = sut.add(params: params);

    // Assert
    expect(future, throwsA(DomainError.emailInUse));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    // Arrange
    final accessToken = faker.guid.guid();
    final name = faker.person.name();

    mockHttpData({
      'accessToken': accessToken,
      'name': name,
    });

    // Act
    final account = await sut.add(params: params);

    // Assert
    expect(account.token, accessToken);
  });
}
