import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  testWidgets('Should call LoadSurveys on page load ',
      (WidgetTester tester) async {
    final presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter))],
    );

    when(() => presenter.loadData()).thenAnswer((_) async => {});

    await tester.pumpWidget(surveysPage);

    verify(() => presenter.loadData()).called(1);
  });
}
