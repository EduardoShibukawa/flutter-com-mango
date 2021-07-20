import 'package:clean_flutter/presentation/presenters/presenters.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(Map input);
}
