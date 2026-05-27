import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'prescricao_model.dart';

class PrescricaoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Prescricao obj) async {
    final db = await dbHelper.database;
    return await db.insert('prescricao', obj.toMap());
  }

  Future<List<Prescricao>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prescricao',
      where: search != null ? 'id_prontuario LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Prescricao.fromMap(e)).toList();
  }

  Future<int> update(Prescricao obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'prescricao',
      obj.toMap(),
      where: 'id_prescricao = ?',
      whereArgs: [obj.id_prescricao],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'prescricao',
      where: 'id_prescricao = ?',
      whereArgs: [id],
    );
  }
}
