import 'package:clean_flutter/data/models/models.dart';
import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteLoadSurveys sut;
  late List<Map> httpData;

  List<Map> mockValidData() => List.filled(3, {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String()
      });

  When mockRequestCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(List<Map> data) =>
      mockRequestCall().thenAnswer((_) async => data);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    httpData = mockValidData();

    mockHttpData(httpData);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final expected = httpData
        .map((e) => SurveyEntity(
              id: e['id'],
              question: e['question'],
              dateTime: DateTime.parse(e['date']),
              didAnswer: e['didAnswer'],
            ))
        .toList();
    final surveys = await sut.load();

    expect(surveys, expected);
  });
}

class RemoteLoadSurveys {
  late String url;
  late HttpClient<List<Map>> httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    final httpResponse = await httpClient.request(url: url, method: 'get');
    return httpResponse
        .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
        .toList();
  }
}
