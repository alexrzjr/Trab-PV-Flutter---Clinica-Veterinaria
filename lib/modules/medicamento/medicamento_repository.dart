import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'medicamento_model.dart';

class MedicamentoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Medicamento obj) async {
    final db = await dbHelper.database;
    return await db.insert('medicamento', obj.toMap());
  }

  Future<List<Medicamento>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'medicamento',
      where: search != null && search.isNotEmpty ? 'nome LIKE ?' : null,
      whereArgs: search != null && search.isNotEmpty ? ['%$search%'] : null,
    );
    return result.map((e) => Medicamento.fromMap(e)).toList();
  }

  Future<int> update(Medicamento obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'medicamento',
      obj.toMap(),
      where: 'id_medicamento = ?',
      whereArgs: [obj.id_medicamento],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'medicamento',
      where: 'id_medicamento = ?',
      whereArgs: [id],
    );
  }
}
