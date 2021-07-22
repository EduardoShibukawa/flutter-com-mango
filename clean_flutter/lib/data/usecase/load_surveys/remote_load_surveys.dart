import 'dart:developer';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements LoadSurveys {
  late String url;
  late HttpClient httpClient;

  RemoteLoadSurveys({
    required this.url,
    required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: 'get') ?? [];

      return httpResponse
          .map((json) => RemoteSurveyModel.fromJson(json).toEntity())
          .cast<SurveyEntity>()
          .toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
