import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'vacina_model.dart';

class VacinaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Vacina obj) async {
    final db = await dbHelper.database;
    return await db.insert('vacina', obj.toMap());
  }

  Future<List<Vacina>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'vacina',
      where: search != null && search.isNotEmpty
          ? 'nome LIKE ?'
          : null,
      whereArgs: search != null && search.isNotEmpty
          ? ['%$search%']
          : null,
    );
    return result.map((e) => Vacina.fromMap(e)).toList();
  }

  Future<int> update(Vacina obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'vacina',
      obj.toMap(),
      where: 'id_vacina = ?',
      whereArgs: [obj.id_vacina],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'vacina',
      where: 'id_vacina = ?',
      whereArgs: [id],
    );
  }
}
