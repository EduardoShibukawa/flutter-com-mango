import 'dart:math';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late RemoteSaveSurveyResult sut;
  late String url;
  late String answer;

  When mockRequestCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData() => mockRequestCall().thenAnswer((_) async => {});

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
    answer = faker.lorem.sentence();

    mockHttpData();
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(() =>
        httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });
}
