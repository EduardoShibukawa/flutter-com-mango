import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import 'protocols/protocols.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/helpers/helpers.dart';
import '../../ui/pages/pages.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  late String _email;
  late String _password;

  var _emailError = RxnString();
  var _passwordError = RxnString();
  var _mainError = RxnString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<String> get passwordErrorStream =>
      _passwordError.stream.map((s) => s!);
  Stream<String> get emailErrorStream => _emailError.stream.map((s) => s!);
  Stream<String> get mainErrorStream => _mainError.stream.map((s) => s!);
  Stream<bool> get isFormValidStream => _isFormValid.stream.map((s) => s!);
  Stream<bool> get isLoadingStream => _isLoading.stream.map((s) => s!);

  GetxLoginPresenter({
    required this.validation,
    required this.authentication,
    required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value =
        validation.validate(field: 'password', value: password);
    _validateForm();
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
    } on DomainError catch (error) {
      _mainError.value = error.description;
      _isLoading.value = false;
    }
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value?.isEmpty == true &&
        _passwordError.value?.isEmpty == true &&
        _password.isNotEmpty &&
        _email.isNotEmpty;
  }

  void dispose();
}
