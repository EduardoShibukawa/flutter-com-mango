import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  HttpClient httpClient;
  String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await this.httpClient.request(url: url, method: 'post');
  }
}
  
abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

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
    // Act
    await sut.auth();

    // Assert
    verify(httpClient.request(
      url: url,
      method: 'post'
      ));
  });
}
  