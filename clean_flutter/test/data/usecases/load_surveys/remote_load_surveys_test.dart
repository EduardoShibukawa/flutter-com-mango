import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('Should call HttpClient with correct values', () async {
    final url = faker.internet.httpUrl();
    final httpClient = HttpClientSpy();
    final sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {});

    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });
}

class RemoteLoadSurveys {
  late String url;
  late HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient,
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: 'get');
  }
}
