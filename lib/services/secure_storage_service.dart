import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  static const _masterPasswordKey = 'master_password_key';

  Future<void> saveMasterPassword(String password) async {
    await _storage.write(key: _masterPasswordKey, value: password);
  }

  Future<String?> getMasterPassword() async {
    return await _storage.read(key: _masterPasswordKey);
  }

  Future<bool> hasMasterPassword() async {
    return await _storage.containsKey(key: _masterPasswordKey);
  }

  Future<void> deleteMasterPassword() async {
    await _storage.delete(key: _masterPasswordKey);
  }
}