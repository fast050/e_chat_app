import 'package:e_chat_app/core/local/local_storage/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsStore implements LocalStore {
  final SharedPreferences prefs;
  SharedPrefsStore(this.prefs);

  @override
  bool? getBool(String key) => prefs.getBool(key);

  @override
  Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);

  @override
  String? getString(String key) => prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) => prefs.setString(key, value);

  @override
  Future<bool> remove(String key) => prefs.remove(key);
}
