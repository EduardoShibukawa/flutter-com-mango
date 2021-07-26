import 'package:clean_flutter/data/usecase/usecase.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  test('Should call remote load', () async {
    final remote = RemoteLoadSurveysSpy();
    final sut = RemoteLoadSurveysWithLocalFallback(remote: remote);

    when(() => remote.load()).thenAnswer((_) async => []);

    await sut.load();

    verify(() => remote.load()).called(1);
  });
}

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({required this.remote});

  Future<void> load() async {
    await remote.load();
  }
}
