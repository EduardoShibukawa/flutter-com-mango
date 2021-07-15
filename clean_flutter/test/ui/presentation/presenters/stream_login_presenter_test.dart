import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presents/protocols/protocols.dart';
import 'package:clean_flutter/presentation/presents/presents.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late Validation validation;
  late String email;
  late String password;

  When mockValidationCall({String? field}) => when(() => validation.validate(
        field: field ?? any(named: 'field'),
        value: any(named: 'value'),
      ));

  void mockValidation({String? field, String? value}) {
    mockValidationCall(field: field).thenReturn(value ?? '');
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit distinct email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit blank if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, ''),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(() => validation.validate(field: 'password', value: password))
        .called(1);
  });

  test('Should emit distinct password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit form invalid if any Field is invalid', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, 'error'),
    ));
    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, ''),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(password);
    sut.validatePassword(password);
  });
}
