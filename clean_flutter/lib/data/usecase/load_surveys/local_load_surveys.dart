import 'package:clean_flutter/domain/usecases/usecases.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../cache/cache.dart';
import '../../models/models.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data?.isEmpty ?? true) throw DomainError.unexpected;

      return _mapToEntity(data);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    final data = await cacheStorage.fetch('surveys');
    try {
      _mapToEntity(data);
    } catch (_) {
      cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      cacheStorage.save(key: 'surveys', value: _mapToJson(surveys));
    } catch (_) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _mapToEntity(List<dynamic> list) => list
      .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
      .toList();

  List<Map<String, String>> _mapToJson(List<SurveyEntity> surveys) =>
      surveys.map((s) => LocalSurveyModel.fromEntity(s).toJson()).toList();
}
