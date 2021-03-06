import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clean_flutter/domain/entities/account_entity.dart';
import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/presentation/presenters/presenters.dart';
import 'package:clean_flutter/ui/helpers/errors/ui_error.dart';

import '../../mocks/mocks.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late GetxSignUpPresenter sut;
  late Validation validation;
  late AddAccount addAccount;
  late SaveCurrentAccount saveCurrentAccount;

  late String email;
  late String name;
  late String password;
  late String passwordConfirmation;

  late AccountEntity account;

  setUpAll(() {
    registerFallbackValue(FakeAddAccountParams());
    registerFallbackValue(FakeAccountEntity());
  });

  When mockValidationCall({String? field}) => when(() => validation.validate(
        field: field ?? any(named: 'field'),
        input: any(named: 'input'),
      ));

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field: field).thenReturn(value);
  }

  When mockAddAccountCall() => when(() => addAccount.add(any()));

  void mockAddAccount(AccountEntity data) {
    account = data;
    mockAddAccountCall().thenAnswer((_) async => data);
  }

  void mockAddAccountError(DomainError error) =>
      mockAddAccountCall().thenThrow(error);

  When mockSaveCurrentAccountCall() =>
      when(() => saveCurrentAccount.save(any()));

  void mockSaveCurrentAccount() =>
      mockSaveCurrentAccountCall().thenAnswer((_) async => {});

  void mockSaveCurrentAccountError() =>
      mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

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

    mockValidation();
    mockAddAccount(FakeAccountFactory.makeEntity());
    mockSaveCurrentAccount();
  });

  test('Should call Validation with correct name', () {
    final formData = {
      'name': name,
      'email': '',
      'password': '',
      'passwordConfirmation': ''
    };

    sut.validateName(name);

    verify(
      () => validation.validate(
        field: 'name',
        input: formData,
      ),
    ).called(1);
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
    final formData = {
      'name': '',
      'email': email,
      'password': '',
      'passwordConfirmation': ''
    };

    sut.validateEmail(email);

    verify(() => validation.validate(
          field: 'email',
          input: formData,
        )).called(1);
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
    final formData = {
      'name': '',
      'email': '',
      'password': password,
      'passwordConfirmation': ''
    };

    sut.validatePassword(password);

    verify(
      () => validation.validate(
        field: 'password',
        input: formData,
      ),
    ).called(1);
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
    final formData = {
      'name': '',
      'email': '',
      'password': '',
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(
      () => validation.validate(
        field: 'passwordConfirmation',
        input: formData,
      ),
    ).called(1);
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

    await sut.signUp();

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

    await sut.signUp();

    verify(
      () => saveCurrentAccount.save(account),
    ).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrentAccount fails', () async {
    mockSaveCurrentAccountError();

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should emit correct events on AddAccount success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true]));
    expectLater(sut.mainErrorStream, emitsInOrder([null]));

    await sut.signUp();
  });

  test('Should emit correct events on EmailInUseError', () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));

    await sut.signUp();
  });

  test('Should emit correct events on UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));

    await sut.signUp();
  });

  test('Should change page on success', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen((page) => expect(page, '/surveys'));
    await sut.signUp();
  });

  test('Should go to LoginPasge on link click', () async {
    sut.navigateToStream.listen((page) => expect(page, '/login'));
    sut.goToLogin();
  });
}
