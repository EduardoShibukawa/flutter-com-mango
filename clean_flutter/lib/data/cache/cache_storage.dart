abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<dynamic> delete(String key);
}
