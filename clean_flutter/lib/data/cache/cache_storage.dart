abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<dynamic> delete(String key);
  Future<dynamic> save({required String key, required dynamic value});
}
