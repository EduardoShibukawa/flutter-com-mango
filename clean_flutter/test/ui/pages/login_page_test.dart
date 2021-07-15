import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late StreamController<String> emailErrorController;
  late StreamController<String> passwordErrorController;
  late StreamController<String> mmainErrorController;
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mmainErrorController = StreamController<String>();

    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();

    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.mainErrorStream)
        .thenAnswer((_) => mmainErrorController.stream);
    when(() => presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    mmainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    expectNoErrosInTextField('Email');
    expectNoErrosInTextField('Senha');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);
    verify(() => presenter.validatePassword(senha));
  });

  testWidgets('should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    expectNoErrosInTextField('Email');
  });

  testWidgets('should present error if password is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add('any error');
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('should present no error if email is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add('');
    await tester.pump();

    expectNoErrosInTextField('Senha');
  });

  testWidgets('should enable button if form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, isNotNull);
  });

  testWidgets('should disable button if form is not valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
  });

  testWidgets('should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });

  testWidgets('should present loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present error message if authentication fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mmainErrorController.add('main error');
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });
}

void expectNoErrosInTextField(String field) {
  final textChildren = find.descendant(
    of: find.bySemanticsLabel(field),
    matching: find.byType(Text),
  );

  expect(
    textChildren,
    findsOneWidget,
    reason:
        'when a TextFormField has only one text child means it has no errors, since one of the childs is always the label text',
  );
}
