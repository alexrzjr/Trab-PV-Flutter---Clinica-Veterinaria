import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'fatura_model.dart';

class FaturaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Fatura obj) async {
    final db = await dbHelper.database;
    return await db.insert('fatura', obj.toMap());
  }

  Future<List<Fatura>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'fatura',
      where: search != null ? 'id_cliente LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Fatura.fromMap(e)).toList();
  }

  Future<int> update(Fatura obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'fatura',
      obj.toMap(),
      where: 'id_fatura = ?',
      whereArgs: [obj.id_fatura],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'fatura',
      where: 'id_fatura = ?',
      whereArgs: [id],
    );
  }
}
