import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';
import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';

@GenerateMocks([HttpClient])
void main() {
  late RemoteAuthentication sut;
  late HttpClient httpClient;
  late String url;

  setUp(() {
    // Arrange
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call HttpClient with correct values', () async {
    // Arrange
    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );

    // Act
    await sut.auth(params);

    // Assert
    verify(httpClient.request(url: url, method: 'post', body: {
      'email': params.email,
      'password': params.secret,
    }));
  });
}
