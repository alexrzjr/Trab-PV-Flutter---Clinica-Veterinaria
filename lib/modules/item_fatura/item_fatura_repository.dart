import '../../core/database/database_helper.dart';
import 'item_fatura_model.dart';

class ItemFaturaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(ItemFatura obj) async {
    final db = await dbHelper.database;
    return db.insert('item_fatura', obj.toMap());
  }

  Future<List<ItemFatura>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'item_fatura',
        where: 'descricao LIKE ?',
        whereArgs: ['%$search%'],
      );
      return result.map(ItemFatura.fromMap).toList();
    }
    final result = await db.query('item_fatura', orderBy: 'id_item DESC');
    return result.map(ItemFatura.fromMap).toList();
  }

  Future<ItemFatura?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'item_fatura',
      where: 'id_item = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return ItemFatura.fromMap(result.first);
  }

  Future<List<ItemFatura>> findByFaturaId(int faturaId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'item_fatura',
      where: 'id_fatura = ?',
      whereArgs: [faturaId],
    );
    return result.map(ItemFatura.fromMap).toList();
  }

  Future<int> update(ItemFatura obj) async {
    final db = await dbHelper.database;
    return db.update(
      'item_fatura',
      obj.toMap(),
      where: 'id_item = ?',
      whereArgs: [obj.idItem],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('item_fatura', where: 'id_item = ?', whereArgs: [id]);
  }
}
