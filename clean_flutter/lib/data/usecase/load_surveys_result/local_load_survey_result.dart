import 'package:clean_flutter/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({required this.cacheStorage});

  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data?.isEmpty ?? true) throw DomainError.unexpected;

      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    final data = await cacheStorage.fetch('survey_result/$surveyId');
    try {
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (_) {
      cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save(SurveyResultEntity surveyResult) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();
      print('survey_result/${surveyResult.surveyId}');
      print(json);
      cacheStorage.save(
          key: 'survey_result/${surveyResult.surveyId}', value: json);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
