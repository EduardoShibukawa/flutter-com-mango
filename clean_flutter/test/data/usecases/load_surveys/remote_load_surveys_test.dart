import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String url;
  late HttpClient httpClient;
  late RemoteLoadSurveys sut;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);

    when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body'),
        )).thenAnswer((_) async => {});
  });

  test('Should call HttpClient with correct values', () async {
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
