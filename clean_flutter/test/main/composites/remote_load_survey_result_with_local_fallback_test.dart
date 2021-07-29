import 'package:clean_flutter/data/usecase/load_surveys_result/load_surveys_result.dart';
import 'package:clean_flutter/domain/entities/entities.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResult local;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  SurveyResultEntity mockSurveyResult() {
    return SurveyResultEntity(
      surveyId: surveyId,
      question: faker.lorem.sentence(),
      answers: [
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100),
        )
      ],
    );
  }

  When mockRemoteLoadCall() =>
      when(() => remote.loadBySurvey(surveyId: any(named: "surveyId")));

  void mockRemoteLoad() {
    surveyId = faker.guid.guid();
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);

    mockRemoteLoad();
    when(() => local.save(surveyResult)).thenAnswer((_) async => {});
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(surveyResult)).called(1);
  });

  test('Should returns remote data', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, surveyResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError',
      () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
    required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    final surveyResult = await remote.loadBySurvey(surveyId: surveyId);

    await local.save(surveyResult);

    return surveyResult;
  }
}
