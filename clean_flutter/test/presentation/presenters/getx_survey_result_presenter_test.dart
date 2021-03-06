import 'package:faker/faker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/presentation/helpers/helpers.dart';
import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/ui/helpers/helpers.dart';

import '../../mocks/mocks.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  late SaveSurveyResultSpy saveSurveyResult;
  late LoadSurveyResultSpy loadSurveyResult;
  late GetxSurveyResultPresenter sut;
  late SurveyResultEntity surveyResult;
  late String surveyId;

  When mockLoadSurveyResultCall() =>
      when(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveyResultError(DomainError error) =>
      mockLoadSurveyResultCall().thenThrow(error);

  setUpAll(() {
    initializeDateFormatting('en_US', null);
  });

  setUp(() {
    saveSurveyResult = SaveSurveyResultSpy();
    loadSurveyResult = LoadSurveyResultSpy();
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(
      saveSurveyResult: saveSurveyResult,
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(FakeSurveyResultFactory.makeEntity());
  });

  group('When loadData is called', () {
    test('Should call LoadSurveys', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });
    test('Should emit correct events on success', () async {
      sut.surveyResultStream
          .listen(expectAsync1((s) => expect(s, surveyResult.toViewModel())));

      await sut.loadData();
    });

    test('Should emit correct events on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description),
          ));

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group('When save is called', () {
    late String answer;
    late SurveyResultEntity saveResult;

    When mockSaveSurveyResultCall() =>
        when(() => saveSurveyResult.save(answer: any(named: 'answer')));

    void mockSaveSurveyResult(SurveyResultEntity data) {
      saveResult = data;
      mockSaveSurveyResultCall().thenAnswer((_) async => data);
    }

    void mockSaveSurveyResultError(DomainError error) =>
        mockSaveSurveyResultCall().thenThrow(error);

    setUp(() {
      answer = faker.lorem.sentence();
      mockSaveSurveyResult(FakeSurveyResultFactory.makeEntity());
    });
    test('Should call LoadSurveys', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.surveyResultStream,
          emitsInOrder([surveyResult.toViewModel(), saveResult.toViewModel()]));
      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emit correct events on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      sut.surveyResultStream.listen(null,
          onError: expectAsync1(
            (error) => expect(error, UIError.unexpected.description),
          ));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
