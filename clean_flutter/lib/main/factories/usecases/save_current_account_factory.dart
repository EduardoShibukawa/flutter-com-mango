import '../factories.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../data/usecase/save_current_account/save_current_account.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() {
  return LocalSaveCurrentAccount(
      saveSecureCacheStorage: makeSecureStorageAdapter());
}
