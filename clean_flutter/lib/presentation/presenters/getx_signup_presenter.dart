import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../mixins/mixins.dart';
import 'presenters.dart';

class GetxSignUpPresenter extends GetxController
    with LoadingManager, NavigateManager, FormManager, UIErrorManager
    implements SignUpPresenter {
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

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get passwordConfirmationErrorStream =>
      _passwordConfirmationError.stream;

  GetxSignUpPresenter({
    required this.validation,
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  Future<void> signUp() async {
    mainError = null;
    isLoading = true;
    try {
      final account = await addAccount.add(
        AddAccountParams(
            name: _name,
            email: _email,
            password: _password,
            passwordConfirmation: _passwordConfirmation),
      );

      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError = UIError.emailInUse;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
      isLoading = false;
    }
  }

  void goToLogin() {
    navigateTo = '/login';
  }

  UIError? _validateField(String field) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };
    final error = validation.validate(field: field, input: formData);

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

    isFormValid = hasNoErrors && hasValues;
  }
}
