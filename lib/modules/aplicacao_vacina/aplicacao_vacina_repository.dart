import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'aplicacao_vacina_model.dart';

class Aplicacao_vacinaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Aplicacao_vacina obj) async {
    final db = await dbHelper.database;
    return await db.insert('aplicacao_vacina', obj.toMap());
  }

  Future<List<Aplicacao_vacina>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'aplicacao_vacina',
      where: search != null ? 'id_prontuario LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Aplicacao_vacina.fromMap(e)).toList();
  }

  Future<int> update(Aplicacao_vacina obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'aplicacao_vacina',
      obj.toMap(),
      where: 'id_aplicacao = ?',
      whereArgs: [obj.id_aplicacao],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'aplicacao_vacina',
      where: 'id_aplicacao = ?',
      whereArgs: [id],
    );
  }
}
