import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'consulta_model.dart';

class ConsultaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Consulta obj) async {
    final db = await dbHelper.database;
    return await db.insert('consulta', obj.toMap());
  }

  Future<List<Consulta>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'consulta',
      where: search != null ? 'id_animal LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<int> update(Consulta obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'consulta',
      obj.toMap(),
      where: 'id_consulta = ?',
      whereArgs: [obj.id_consulta],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'consulta',
      where: 'id_consulta = ?',
      whereArgs: [id],
    );
  }
}
