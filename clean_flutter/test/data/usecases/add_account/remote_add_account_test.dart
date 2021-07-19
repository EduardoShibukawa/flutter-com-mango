import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
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
}
