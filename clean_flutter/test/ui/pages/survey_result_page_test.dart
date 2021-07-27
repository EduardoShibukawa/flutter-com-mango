import 'dart:async';

import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {}

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
            name: '/survey_result/:survey_id',
            page: () => SurveyResultPage(presenter))
      ],
    );

    when(() => presenter.loadData()).thenAnswer((_) async => {});

    mockNetworkImagesFor(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  testWidgets('Should call LoadSurveyResult on page load ',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });
}
