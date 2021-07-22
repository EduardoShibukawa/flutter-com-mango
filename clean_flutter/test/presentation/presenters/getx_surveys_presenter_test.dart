import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/entities/survey_entity.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/ui/helpers/helpers.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 2, 20),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2018, 10, 3),
          didAnswer: false,
        ),
      ];

  When mockLoadSurveysCall() => when(() => loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUpAll(() {
    initializeDateFormatting('en_US', null);
  });

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });
  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(expectAsync1((s) => expect(s, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: '20 fev 2020',
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: '03 out 2018',
            didAnswer: surveys[1].didAnswer,
          ),
        ])));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadSurveysError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ));

    await sut.loadData();
  });
}
