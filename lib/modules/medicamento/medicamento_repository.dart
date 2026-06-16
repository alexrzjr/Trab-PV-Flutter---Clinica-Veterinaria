import '../../core/database/database_helper.dart';
import 'medicamento_model.dart';

class MedicamentoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Medicamento obj) async {
    final db = await dbHelper.database;
    return db.insert('medicamento', obj.toMap());
  }

  Future<List<Medicamento>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'medicamento',
        where: 'nome LIKE ? OR tipo LIKE ? OR lote LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Medicamento.fromMap).toList();
    }
    final result = await db.query('medicamento', orderBy: 'nome ASC');
    return result.map(Medicamento.fromMap).toList();
  }

  Future<Medicamento?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'medicamento',
      where: 'id_medicamento = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Medicamento.fromMap(result.first);
  }

  Future<int> update(Medicamento obj) async {
    final db = await dbHelper.database;
    return db.update(
      'medicamento',
      obj.toMap(),
      where: 'id_medicamento = ?',
      whereArgs: [obj.idMedicamento],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('medicamento', where: 'id_medicamento = ?', whereArgs: [id]);
  }
}
