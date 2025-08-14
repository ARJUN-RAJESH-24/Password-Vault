import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:password_vault_app/models/credential.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'credentials';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'password_vault.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            username TEXT,
            encryptedPassword TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertCredential(Credential credential) async {
    final db = await database;
    await db.insert(_tableName, credential.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Credential>> getCredentials() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Credential.fromMap(maps[i]);
    });
  }

  Future<void> updateCredential(Credential credential) async {
    final db = await database;
    await db.update(
      _tableName,
      credential.toMap(),
      where: 'id = ?',
      whereArgs: [credential.id],
    );
  }

  Future<void> deleteCredential(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}