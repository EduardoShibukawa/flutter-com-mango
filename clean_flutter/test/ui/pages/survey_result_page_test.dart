import 'dart:async';

import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;
  late StreamController<List<dynamic>> surveyResultController;

  void initStreams() {
    surveyResultController = StreamController();
  }

  void closeStreams() {
    surveyResultController.close();
  }

  void mockStreams() {
    when(() => presenter.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    initStreams();
    mockStreams();

    when(() => presenter.loadData()).thenAnswer((_) async => {});

    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
            name: '/survey_result/:survey_id',
            page: () => SurveyResultPage(presenter))
      ],
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveyResult on page load ',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should present error if surveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
