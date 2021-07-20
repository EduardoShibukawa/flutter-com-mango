import 'package:clean_flutter/domain/entities/account_entity.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/ui/helpers/errors/ui_error.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class FakeAddAccountParams extends Fake implements AddAccountParams {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

class FakeAccountEntity extends Fake implements AccountEntity {}

void main() {
  late GetxSignUpPresenter sut;
  late Validation validation;
  late AddAccount addAccount;
  late SaveCurrentAccount saveCurrentAccount;

  late String email;
  late String name;
  late String password;
  late String passwordConfirmation;

  late String token;

  setUpAll(() {
    registerFallbackValue(FakeAddAccountParams());
    registerFallbackValue(FakeAccountEntity());
  });

  When mockValidationCall({String? field}) => when(() => validation.validate(
        field: field ?? any(named: 'field'),
        value: any(named: 'value'),
      ));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  When mockAddAccountCall() => when(() => addAccount.add(any()));

  void mockAddAccount() =>
      mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() =>
      mockSaveCurrentAccountCall().thenAnswer((_) async => {});

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = password;
    token = faker.guid.guid();
    mockValidation();
    mockAddAccount();
    mockSaveCurrentAccount();
  });

  test('Should call Validation with correct name', () {
    sut.validateName(name);

    verify(() => validation.validate(field: 'name', value: name)).called(1);
  });

  test('Should emit invalidFieldError if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.invalidField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredFieldError if name is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.requiredField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if name validation succeeds', () {
    sut.nameErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.invalidField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.requiredField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if email validation succeeds', () {
    sut.emailErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
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

  test('Should emit invalidFieldError if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.invalidField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredFieldError if password is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.requiredField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if password validation succeeds', () {
    sut.passwordErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should call Validation with correct password confirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(() => validation.validate(
        field: 'passwordConfirmation', value: passwordConfirmation)).called(1);
  });

  test('Should emit invalidFieldError if password confirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.invalidField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredFieldError if password confirmation is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.requiredField),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if password confirmation validation succeeds', () {
    sut.passwordConfirmationErrorStream.listen(expectAsync1(
      (error) => expect(error, null),
    ));
    sut.isFormValidStream.listen(expectAsync1(
      (isValid) => expect(isValid, false),
    ));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable button if all fields are valid ', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Should call AddAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signup();

    verify(
      () => addAccount.add(
        AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      ),
    ).called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signup();

    verify(
      () => saveCurrentAccount.save(AccountEntity(token)),
    ).called(1);
  });
}
