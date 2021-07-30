import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult {
  late String url;
  late HttpClient httpClient;

  RemoteSaveSurveyResult({
    required this.url,
    required this.httpClient,
  });

  Future<void> save({required String answer}) async {
    try {
      await httpClient.request(
        url: url,
        method: 'put',
        body: {'answer': answer},
      );
    } catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
