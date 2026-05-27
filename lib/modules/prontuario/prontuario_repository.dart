import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'prontuario_model.dart';

class ProntuarioRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Prontuario obj) async {
    final db = await dbHelper.database;
    return await db.insert('prontuario', obj.toMap());
  }

  Future<List<Prontuario>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prontuario',
      where: search != null ? 'id_animal LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Prontuario.fromMap(e)).toList();
  }

  Future<int> update(Prontuario obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'prontuario',
      obj.toMap(),
      where: 'id_prontuario = ?',
      whereArgs: [obj.id_prontuario],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'prontuario',
      where: 'id_prontuario = ?',
      whereArgs: [id],
    );
  }
}
