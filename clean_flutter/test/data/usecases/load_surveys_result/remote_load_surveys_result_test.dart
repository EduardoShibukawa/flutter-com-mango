import 'dart:math';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/http/http.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late String url;
  late HttpClientSpy httpClient;
  late RemoteLoadSurveysResult sut;
  late Map surveyResult;

  Map mockValidData() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': List.filled(new Random().nextInt(10), {
          'image': faker.internet.httpUrl(),
          'answer': faker.randomGenerator.string(20),
          'percent': faker.randomGenerator.integer(100),
          'count': faker.randomGenerator.integer(1000),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        }),
        'date': faker.date.dateTime().toIso8601String()
      };

  When mockRequestCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
      ));

  void mockHttpData(Map data) =>
      mockRequestCall().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequestCall().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveysResult(url: url, httpClient: httpClient);
    surveyResult = mockValidData();

    mockHttpData(surveyResult);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final answers = surveyResult['answers']
        .map<SurveyAnswerEntity>((e) => SurveyAnswerEntity(
              image: e['image'],
              answer: e['answer'],
              isCurrentAnswer: e['isCurrentAccountAnswer'],
              percent: e['percent'],
            ))
        .toList();

    final surveys = await sut.loadBySurvey();

    expect(
        surveys,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: answers,
        ));
  });

  test(
      'Should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData({'invalid_data': 'invalid_key'});
    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
