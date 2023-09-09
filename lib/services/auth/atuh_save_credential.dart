import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSaveCredentials {
  final _storage = const FlutterSecureStorage();

  Future<void> add(String key, String value) async {
    _storage.write(key: key, value: value, aOptions: _getAndroidOptions());
  }

  Future<String?> getByKey(String key) async {
    final valor = await _storage.read(key: key, aOptions: _getAndroidOptions());
    return valor;
  }

  Future<void> getAll() async {
    final valor = await _storage.readAll(aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}