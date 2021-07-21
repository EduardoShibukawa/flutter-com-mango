import 'dart:async';

import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mocktail/mocktail.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  late SurveysPresenterSpy presenter;
  late StreamController<List<SurveyViewModel>> loadSurveysController;
  late StreamController<bool> isLoadingController;

  void initStreams() {
    loadSurveysController = StreamController();
    isLoadingController = StreamController();
  }

  void closeStreams() {
    loadSurveysController.close();
    isLoadingController.close();
  }

  void mockStreams() {
    when(() => presenter.loadSurveyStream)
        .thenAnswer((_) => loadSurveysController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter))],
    );

    when(() => presenter.loadData()).thenAnswer((_) async => {});

    await tester.pumpWidget(surveysPage);
  }

  tearDown(() {
    closeStreams();
  });

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  testWidgets('Should call LoadSurveys on page load ',
      (WidgetTester tester) async {
    await loadPage(tester);
    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if loadSurveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'),
        findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });
}
