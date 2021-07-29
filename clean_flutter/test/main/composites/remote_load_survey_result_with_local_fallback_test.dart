import 'package:clean_flutter/data/usecase/load_surveys_result/load_surveys_result.dart';
import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  test('Should call remote LoadBySurvey', () {
    final remote = RemoteLoadSurveyResultSpy();
    final sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote);
    final surveyId = faker.guid.guid();

    when(() => remote.loadBySurvey(surveyId: any(named: "surveyId")))
        .thenAnswer((_) async => SurveyResultEntity(
              surveyId: faker.guid.guid(),
              question: faker.lorem.sentence(),
              answers: [],
            ));

    sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({required this.remote});

  Future<void> loadBySurvey({required String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}
