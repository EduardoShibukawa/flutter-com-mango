import 'dart:async';

import 'package:clean_flutter/ui/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clean_flutter/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  Future<void> loadPage(WidgetTester tester) async {
    final signUpPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => SignUpPage(),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

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
