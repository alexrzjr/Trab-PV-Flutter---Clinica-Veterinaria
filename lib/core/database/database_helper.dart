import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:clinica_veterinaria/core/database/schema.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Schema.createCliente);
    await db.execute(Schema.createAnimal);
    await db.execute(Schema.createProfissional);
    await db.execute(Schema.createConsulta);
    await db.execute(Schema.createProntuario);
    await db.execute(Schema.createMedicamento);
    await db.execute(Schema.createVacina);
    await db.execute(Schema.createPrescricao);
    await db.execute(Schema.createAplicacaoVacina);
    await db.execute(Schema.createFatura);
    await db.execute(Schema.createItemFatura);
  }
}
