import '../../core/database/database_helper.dart';
import 'pagamento_model.dart';

class PagamentoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Pagamento obj) async {
    final db = await dbHelper.database;
    return db.insert('pagamento', obj.toMap());
  }

  Future<List<Pagamento>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'pagamento',
        where: 'forma_pagamento LIKE ? OR data_pagamento LIKE ?',
        whereArgs: ['%$search%', '%$search%'],
      );
      return result.map(Pagamento.fromMap).toList();
    }
    final result = await db.query('pagamento', orderBy: 'data_pagamento DESC');
    return result.map(Pagamento.fromMap).toList();
  }

  Future<Pagamento?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'pagamento',
      where: 'id_pagamento = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Pagamento.fromMap(result.first);
  }

  Future<int> update(Pagamento obj) async {
    final db = await dbHelper.database;
    return db.update(
      'pagamento',
      obj.toMap(),
      where: 'id_pagamento = ?',
      whereArgs: [obj.idPagamento],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('pagamento', where: 'id_pagamento = ?', whereArgs: [id]);
  }

  Future<List<Pagamento>> findByFaturaId(int faturaId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'pagamento',
      where: 'id_fatura = ?',
      whereArgs: [faturaId],
    );
    return result.map(Pagamento.fromMap).toList();
  }
}
