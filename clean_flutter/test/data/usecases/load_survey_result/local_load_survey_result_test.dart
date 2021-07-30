import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/data/cache/cache.dart';
import 'package:clean_flutter/data/usecase/load_survey_result/local_load_survey_result.dart';
import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group('Load', () {
    late CacheStorage cacheStorage;
    late LocalLoadSurveyResult sut;
    late String surveyId;
    late Map? loadData;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(Map? data) {
      loadData = data;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

      surveyId = faker.guid.guid();
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
    });
    test('Should call FectchCacheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should return SurveyResult on success', () async {
      mockFetch(loadData);

      final surveys = await sut.loadBySurvey(surveyId: surveyId);

      expect(
          surveys,
          SurveyResultEntity(
            surveyId: loadData!['surveyId'],
            question: loadData!['question'],
            answers: [
              SurveyAnswerEntity(
                image: loadData!['answers'][0]['image'],
                answer: loadData!['answers'][0]['answer'],
                isCurrentAnswer: true,
                percent: 40,
              ),
              SurveyAnswerEntity(
                answer: loadData!['answers'][1]['answer'],
                isCurrentAnswer: false,
                percent: 60,
              ),
            ],
          ));
    });

    test('Should throw UnexpectedError if cache is empty', () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
    test('Should throw UnexpectedError if cache is null', () async {
      mockFetch(null);

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch(FakeSurveyResultFactory.makeIncompleteCacheJson());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Validate', () {
    late CacheStorage cacheStorage;
    late LocalLoadSurveyResult sut;
    late String surveyId;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(Map? data) => mockFetchCall().thenAnswer((_) async => data);

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);

      surveyId = faker.guid.guid();
      mockFetch(FakeSurveyResultFactory.makeCacheJson());
      when(() => cacheStorage.delete(any())).thenAnswer((_) async => {});
    });

    test('Should call FectchCacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch(FakeSurveyResultFactory.makeInvalidCacheJson());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch({'surveyId': faker.guid.guid()});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should delete if cache throws', () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('Save', () {
    late CacheStorage cacheStorage;
    late LocalLoadSurveyResult sut;
    late SurveyResultEntity surveyResult;

    When mockSaveCall() => when(() =>
        cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyResult = FakeSurveyResultFactory.makeEntity();

      when(() => cacheStorage.save(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => {});
    });

    test('Should call FectchCacheStorage with correct values', () async {
      final result = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'isCurrentAnswer': 'true',
            'percent': '40',
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'isCurrentAnswer': 'false',
            'percent': '60',
          }
        ],
      };

      await sut.save(surveyResult);

      verify(() => cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}',
          value: result)).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      mockSaveError();

      final future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
