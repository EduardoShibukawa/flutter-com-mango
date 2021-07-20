import 'dart:async';

import 'package:clean_flutter/domain/helpers/helpers.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import 'presenters.dart';

import '../../domain/usecases/usecases.dart';

import '../../ui/pages/pages.dart';
import '../../ui/helpers/errors/errors.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email = '';
  String _password = '';

  var _emailError = Rxn<UIError?>();
  var _passwordError = Rxn<UIError?>();
  var _mainError = Rxn<UIError?>();
  var _navigateTo = RxnString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError?> get passwordErrorStream => _passwordError.stream;
  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.map((s) => s!);
  Stream<bool> get isFormValidStream => _isFormValid.stream.map((s) => s!);
  Stream<bool> get isLoadingStream => _isLoading.stream.map((s) => s!);

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
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

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      final account = await authentication.auth(
        params: AuthenticationParams(
          email: _email,
          secret: _password,
        ),
      );
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentialsError:
          _mainError.value = UIError.invalidCredentialsError;
          break;
        default:
          _mainError.value = UIError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _password.isNotEmpty &&
        _email.isNotEmpty;
  }
}
