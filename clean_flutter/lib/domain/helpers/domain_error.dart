enum DomainError { unexpected, invalidCredentialsError }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentialsError:
        return 'Credenciais inválidas.';
      default:
        return '';
    }
  }
}
