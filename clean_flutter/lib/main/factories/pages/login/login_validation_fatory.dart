import 'package:clean_flutter/main/builders/validation_builder.dart';

import '../../../../presentation/presenters/protocols/protocols.dart';
import '../../../../validation/valdation.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
