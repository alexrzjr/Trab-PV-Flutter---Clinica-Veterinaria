import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:clinica_veterinaria/core/database/schema.dart';
import 'package:clinica_veterinaria/core/database/seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;
  static const _dbVersion = 3;

  DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'clinica_veterinaria.db');

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    for (final sql in Schema.allTables) {
      await db.execute(sql);
    }
    await SeedData.seedIfEmpty(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      final tables = [
        'pagamento', 'item_fatura', 'fatura', 'aplicacao_vacina', 'prescricao',
        'vacina', 'medicamento', 'prontuario', 'consulta', 'sala_atendimento',
        'profissional', 'animal', 'cliente', 'usuario',
      ];
      for (final t in tables) {
        await db.execute('DROP TABLE IF EXISTS $t');
      }
      for (final sql in Schema.allTables) {
        await db.execute(sql);
      }
      await SeedData.seedIfEmpty(db);
    }
  }
}
