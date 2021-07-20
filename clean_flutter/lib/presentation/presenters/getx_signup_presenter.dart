import 'dart:async';

import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:clean_flutter/domain/usecases/usecases.dart';
import 'package:clean_flutter/ui/pages/pages.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/helpers/errors/errors.dart';
import 'presenters.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  String _name = '';
  String _email = '';
  String _password = '';
  String _passwordConfirmation = '';

  var _emailError = Rxn<UIError?>();
  var _nameError = Rxn<UIError?>();
  var _passwordError = Rxn<UIError?>();
  var _passwordConfirmationError = Rxn<UIError?>();
  var _mainError = Rxn<UIError?>();

  var _navigateTo = RxnString();

  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;

  Stream<String> get navigateToStream => _navigateTo.map((s) => s!);

  Stream<bool> get isFormValidStream => _isFormValid.stream.map((s) => s!);
  Stream<bool> get isLoadingStream => _isLoading.stream.map((s) => s!);

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
    _validateForm();
  }

  Future<void> signUp() async {
    _isLoading.value = true;
    try {
      final account = await addAccount.add(
        AddAccountParams(
            name: _name,
            email: _email,
            password: _password,
            passwordConfirmation: _passwordConfirmation),
      );

      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    final hasNoErrors = _nameError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null;

    final hasValues = _password.isNotEmpty &&
        _email.isNotEmpty &&
        _passwordConfirmation.isNotEmpty &&
        _name.isNotEmpty;

    _isFormValid.value = hasNoErrors && hasValues;
  }
}
