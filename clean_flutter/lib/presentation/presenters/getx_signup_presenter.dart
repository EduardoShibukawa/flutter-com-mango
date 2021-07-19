import 'dart:async';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';

import '../../ui/helpers/errors/errors.dart';
import 'presenters.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;

  var _emailError = Rxn<UIError?>();
  var _nameError = Rxn<UIError?>();
  var _isFormValid = false.obs;

  Stream<UIError?> get emailErrorStream => _emailError.stream;
  Stream<UIError?> get nameErrorStream => _nameError.stream;

  Stream<bool> get isFormValidStream => _isFormValid.stream.map((s) => s!);

  GetxSignUpPresenter({
    required this.validation,
  });

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _nameError.value = _validateField(field: 'name', value: name);
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

  void _validateForm() {
    _isFormValid.value = false;
  }

  void dispose();
}
