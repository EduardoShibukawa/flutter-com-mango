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

class FakeSurveyResultEntity extends Fake implements SurveyResultEntity {}

void main() {
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResult local;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late String surveyId;
  late SurveyResultEntity remoteResult;
  late SurveyResultEntity localResult;

  setUpAll(() {
    registerFallbackValue(FakeSurveyResultEntity());
  });

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
    remoteResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  When mockLocalLoadCall() =>
      when(() => local.loadBySurvey(surveyId: any(named: "surveyId")));

  void mockLocalLoad() {
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();

    mockRemoteLoad();
    mockLocalLoad();
    when(() => local.save(any())).thenAnswer((_) async => {});
    when(() => local.validate(any())).thenAnswer((_) async => {});
  });

  test('Should call remote LoadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('Should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteResult)).called(1);
  });

  test('Should returns remote data', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    expect(result, remoteResult);
  });

  test('Should rethrow if remote LoadBySurvey throws AccessDeniedError',
      () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local LoadBySurvey on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
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
    try {
      final surveyResult = await remote.loadBySurvey(surveyId: surveyId);

      await local.save(surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;

      local.validate(surveyId);
      return local.loadBySurvey(surveyId: surveyId);
    }
  }
}
