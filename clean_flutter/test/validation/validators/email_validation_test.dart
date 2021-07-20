import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('email');
  });

  test('Should return null on invalid cases', () {
    expect(sut.validate({}), null);
  });

  test('Should return null if email is empty', () {
    final formData = {
      'email': '',
    };
    expect(sut.validate(formData), null);
  });

  test('Should return null if email is null', () {
    final formData = {
      'email': null,
    };
    expect(sut.validate(formData), null);
  });

  test('Should return null if email is valid', () {
    final formData = {
      'email': 'eduardoshibuka@gmail.com',
    };
    expect(sut.validate(formData), null);
  });

  test('Should return error if email is invalid', () {
    final formData = {
      'email': 'eduardoshibuka@gmail',
    };
    expect(sut.validate(formData), ValidationError.invalidField);
  });
}
