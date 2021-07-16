import 'package:clean_flutter/main/builders/validation_builder.dart';
import 'package:test/test.dart';

void main() {
  test('should not allow to use public constructor', () {
    expect(() => new ValidationBuilder(), throwsException);
  });
}
