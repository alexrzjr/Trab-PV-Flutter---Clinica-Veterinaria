import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'item_fatura_model.dart';

class Item_faturaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Item_fatura obj) async {
    final db = await dbHelper.database;
    return await db.insert('item_fatura', obj.toMap());
  }

  Future<List<Item_fatura>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'item_fatura',
      where: search != null ? 'id_fatura LIKE ?' : null,
      whereArgs: search != null ? ['%%'] : null,
    );
    return result.map((e) => Item_fatura.fromMap(e)).toList();
  }

  Future<int> update(Item_fatura obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'item_fatura',
      obj.toMap(),
      where: 'id_item = ?',
      whereArgs: [obj.id_item],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'item_fatura',
      where: 'id_item = ?',
      whereArgs: [id],
    );
  }
}
