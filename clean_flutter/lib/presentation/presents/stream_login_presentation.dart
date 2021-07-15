import 'dart:async';

import 'package:clean_flutter/domain/entities/entities.dart';

import 'protocols/protocols.dart';
import '../../domain/usecases/usecases.dart';

class LoginState {
  String email = '';
  String password = '';
  String emailError = '';
  String passwordError = '';
  bool isLoading = false;

  bool get isFormValid =>
      emailError.isEmpty &&
      passwordError.isEmpty &&
      password.isNotEmpty &&
      email.isNotEmpty;
}

class StreamLoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  Stream<bool> get isLoadingStream =>
      _controller.stream.map((state) => state.isLoading).distinct();

  StreamLoginPresenter(
      {required this.validation, required this.authentication});

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email);

    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError =
        validation.validate(field: 'password', value: password);

    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    await authentication.auth(
      params: AuthenticationParams(
        email: _state.email,
        secret: _state.password,
      ),
    );
    _state.isLoading = false;
  }

  void _update() {
    _controller.add(_state);
  }
}
