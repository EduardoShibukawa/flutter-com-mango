import 'package:clean_flutter/domain/entities/survey_entity.dart';
import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/usecases/usecases.dart';

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

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    when(() => loadSurveys.load()).thenAnswer((_) async => data);
  }

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

    await sut.loadData();
  });

  test('Should emit correct events on success', () async {
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
}

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.map((e) => e!);
  Stream<List<SurveyViewModel>> get surveysStream =>
      _surveys.stream.map((e) => e!);

  GetxSurveysPresenter(this.loadSurveys);

  Future<void> loadData() async {
    _isLoading.value = true;
    final surveys = await loadSurveys.load();
    _surveys.value = surveys
        .map(
          (s) => SurveyViewModel(
            id: s.id,
            question: s.question,
            date: Intl.withLocale(
              R.locale.toString(),
              () => DateFormat('dd MMM yyyy').format(s.dateTime),
            ),
            didAnswer: s.didAnswer,
          ),
        )
        .toList();
    _isLoading.value = false;
  }
}
