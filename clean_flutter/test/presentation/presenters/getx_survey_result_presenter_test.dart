import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:clean_flutter/ui/pages/survey_result/components/survey_result.dart';
import 'package:faker/faker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  late SaveSurveyResultSpy saveSurveyResult;
  late LoadSurveyResultSpy loadSurveyResult;
  late GetxSurveyResultPresenter sut;
  late SurveyResultEntity surveyResult;
  late String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              isCurrentAnswer: faker.randomGenerator.boolean(),
              percent: faker.randomGenerator.integer(100),
            ),
          ]);

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
    mockLoadSurveyResult(mockValidData());
  });

  group('When loadData is called', () {
    test('Should call LoadSurveys', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });
    test('Should emit correct events on success', () async {
      sut.surveyResultStream.listen(expectAsync1((s) => expect(
          s,
          SurveyResultViewModel(
            surveyId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: surveyResult.answers[0].image,
                answer: surveyResult.answers[0].answer,
                isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                percent: '${surveyResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: surveyResult.answers[1].answer,
                isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                percent: '${surveyResult.answers[1].percent}%',
              )
            ],
          ))));

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

    setUp(() {
      answer = faker.lorem.sentence();
      mockSaveSurveyResult(mockValidData());
    });
    test('Should call LoadSurveys', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      sut.surveyResultStream.listen(expectAsync1((s) => expect(
          s,
          SurveyResultViewModel(
            surveyId: saveResult.surveyId,
            question: saveResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: saveResult.answers[0].image,
                answer: saveResult.answers[0].answer,
                isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                percent: '${saveResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: saveResult.answers[1].answer,
                isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                percent: '${saveResult.answers[1].percent}%',
              )
            ],
          ))));

      await sut.save(answer: answer);
    });
  });
}
