import '../../data/usecase/usecase.dart';
import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

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