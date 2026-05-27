import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'animal_model.dart';

class AnimalRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Animal obj) async {
    final db = await dbHelper.database;
    return await db.insert('animal', obj.toMap());
  }

  Future<List<Animal>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'animal',
      where: search != null && search.isNotEmpty
          ? 'nome LIKE ?'
          : null,
      whereArgs: search != null && search.isNotEmpty
          ? ['%$search%']
          : null,
          );
    return result.map((e) => Animal.fromMap(e)).toList();
  }

  Future<int> update(Animal obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'animal',
      obj.toMap(),
      where: 'id_animal = ?',
      whereArgs: [obj.id_animal],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'animal',
      where: 'id_animal = ?',
      whereArgs: [id],
    );
  }
}
