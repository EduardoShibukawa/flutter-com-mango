import 'dart:async';

import 'protocols/protocols.dart';

class LoginState {
  String email = '';
  String password = '';
  String emailError = '';
  String passwordError = '';

  bool get isFormValid =>
      emailError.isEmpty &&
      passwordError.isEmpty &&
      password.isNotEmpty &&
      email.isNotEmpty;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();

  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  StreamLoginPresenter({required this.validation});

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

  void _update() {
    _controller.add(_state);
  }
}
