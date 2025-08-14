import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:password_vault_app/services/secure_storage_service.dart';

class EncryptionService {
  final SecureStorageService _secureStorageService = SecureStorageService();
  late final Key _key;
  late final IV _iv;

  Future<void> init() async {
    final masterPassword = await _secureStorageService.getMasterPassword();
    if (masterPassword == null) {
      throw Exception('Master password not found.');
    }
    // Derive a 32-byte key from the master password for AES-256
    _key = Key.fromUtf8(masterPassword.padRight(32, ' '));
    // IV (Initialization Vector) is a fixed value for simplicity in this example
    _iv = IV.fromLength(16);
  }

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}