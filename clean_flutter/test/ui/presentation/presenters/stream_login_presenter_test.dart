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
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validaEmail(email);

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

    sut.validaEmail(email);
    sut.validaEmail(email);
  });

  test('Should emit blank if validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, ''),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validaEmail(email);
    sut.validaEmail(email);
  });
}
