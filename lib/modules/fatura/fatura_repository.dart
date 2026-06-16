import '../../core/database/database_helper.dart';
import 'fatura_model.dart';

class FaturaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Fatura obj) async {
    final db = await dbHelper.database;
    return db.insert('fatura', obj.toMap());
  }

  Future<List<Fatura>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'fatura',
        where: 'status LIKE ? OR data_fatura LIKE ?',
        whereArgs: ['%$search%', '%$search%'],
      );
      return result.map(Fatura.fromMap).toList();
    }
    final result = await db.query('fatura', orderBy: 'data_fatura DESC');
    return result.map(Fatura.fromMap).toList();
  }

  Future<Fatura?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'fatura',
      where: 'id_fatura = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Fatura.fromMap(result.first);
  }

  Future<int> update(Fatura obj) async {
    final db = await dbHelper.database;
    return db.update(
      'fatura',
      obj.toMap(),
      where: 'id_fatura = ?',
      whereArgs: [obj.idFatura],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('fatura', where: 'id_fatura = ?', whereArgs: [id]);
  }

  Future<void> updateValorTotal(int id, double total, {required String status}) async {
    final db = await dbHelper.database;
    await db.update(
      'fatura',
      {'valor_total': total, 'status': status},
      where: 'id_fatura = ?',
      whereArgs: [id],
    );
  }
}
