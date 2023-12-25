import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> save(String key, String value);

  Future<String> get(String key);

  Future<void> clearStorage();

  Future<void> remove(String key);
}

class SecureStorage implements LocalStorage {
  SecureStorage();

  @override
  Future<void> clearStorage() async {
    final storage = await SharedPreferences.getInstance();
    await storage.clear();
  }

  @override
  Future<String> get(String key) async {
    final storage = await SharedPreferences.getInstance();
    String? value = storage.getString(key);
    return value ?? '';
  }

  @override
  Future<void> remove(String key) async {
    final storage = await SharedPreferences.getInstance();
    await storage.remove(key);
  }

  @override
  Future<void> save(String key, String value) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString(key, value);
  }
}
