import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'profissional_model.dart';

class ProfissionalRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Profissional obj) async {
    final db = await dbHelper.database;
    return await db.insert('profissional', obj.toMap());
  }

  Future<List<Profissional>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'profissional',
      where: search != null && search.isNotEmpty
          ? 'nome LIKE ?'
          : null,
      whereArgs: search != null && search.isNotEmpty
          ? ['%$search%']
          : null,
    );
    return result.map((e) => Profissional.fromMap(e)).toList();
  }

  Future<int> update(Profissional obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'profissional',
      obj.toMap(),
      where: 'id_profissional = ?',
      whereArgs: [obj.id_profissional],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'profissional',
      where: 'id_profissional = ?',
      whereArgs: [id],
    );
  }
}
