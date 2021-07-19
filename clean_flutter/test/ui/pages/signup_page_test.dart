import 'dart:async';

import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  late SignUpPresenter presenter;
  late StreamController<UIError?> nameErrorController;
  late StreamController<UIError?> emailErrorController;
  late StreamController<UIError?> passwordErrorController;
  late StreamController<UIError?> passwordConfirmationErrorController;

  void initStreams() {
    nameErrorController = StreamController<UIError?>();
    emailErrorController = StreamController<UIError?>();
    passwordErrorController = StreamController<UIError?>();
    passwordConfirmationErrorController = StreamController<UIError?>();
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
  }

  void mockStreams() {
    when(() => presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(() => presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => SignUpPage(presenter),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    expectNoErrosInTextField('Nome');
    expectNoErrosInTextField('Email');
    expectNoErrosInTextField('Senha');
    expectNoErrosInTextField('Confirmar senha');

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));

    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(() => presenter.validateName(name)).called(1);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email)).called(1);

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);
    verify(() => presenter.validatePassword(senha)).called(1);

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), senha);
    verify(() => presenter.validatePasswordConfirmation(senha)).called(1);
  });

  testWidgets('Should present mail error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();

    expectNoErrosInTextField('Email');
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
