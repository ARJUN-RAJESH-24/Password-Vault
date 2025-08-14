import 'package:flutter/foundation.dart';
import 'package:password_vault_app/models/credential.dart';
import 'package:password_vault_app/services/database_service.dart';
import 'package:password_vault_app/services/encryption_services.dart';

class CredentialProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();
  List<Credential> _credentials = [];

  List<Credential> get credentials => _credentials;

  Future<void> loadCredentials() async {
    await _encryptionService.init(); // Initialize encryption service
    _credentials = await _databaseService.getCredentials();
    notifyListeners();
  }

  Future<void> addCredential(Credential credential) async {
    final encryptedPassword = _encryptionService.encrypt(credential.encryptedPassword);
    final newCredential = Credential(
      title: credential.title,
      username: credential.username,
      encryptedPassword: encryptedPassword,
    );
    await _databaseService.insertCredential(newCredential);
    await loadCredentials(); // Reload all credentials to update the list
  }

  Future<void> updateCredential(Credential credential) async {
    final encryptedPassword = _encryptionService.encrypt(credential.encryptedPassword);
    final updatedCredential = Credential(
      id: credential.id,
      title: credential.title,
      username: credential.username,
      encryptedPassword: encryptedPassword,
    );
    await _databaseService.updateCredential(updatedCredential);
    await loadCredentials();
  }

  Future<void> deleteCredential(int id) async {
    await _databaseService.deleteCredential(id);
    await loadCredentials();
  }

  String decryptPassword(String encryptedPassword) {
    return _encryptionService.decrypt(encryptedPassword);
  }
}