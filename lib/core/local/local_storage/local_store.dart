

abstract interface class LocalStore {
  bool? getBool(String key);
  Future<bool> setBool(String key, bool value);

  String? getString(String key);
  Future<bool> setString(String key, String value);

  Future<bool> remove(String key);
}
