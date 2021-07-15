import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late StreamLoginPresenter sut;
  late Validation validation;
  late String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    when(() => validation.validate(
          field: any(named: 'field'),
          value: any(named: 'value'),
        )).thenAnswer((_) => '');
  });

  test('Should call Validation with correct email', () {
    sut.validaEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });
}

abstract class Validation {
  String validate({required String field, required String value});
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({required this.validation});

  void validaEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}
