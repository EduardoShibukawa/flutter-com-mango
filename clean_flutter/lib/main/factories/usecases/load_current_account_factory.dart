import '../factories.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../data/usecase/load_current_account/local_load_current_account.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
      fetchSecureCacheStorage: makeSecureStorageAdapter());
}
