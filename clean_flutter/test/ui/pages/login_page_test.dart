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

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    expectNoErrosInTextField('Email');
    expectNoErrosInTextField('Senha');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
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
