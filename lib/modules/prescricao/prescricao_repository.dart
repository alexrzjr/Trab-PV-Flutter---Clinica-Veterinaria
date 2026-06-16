import '../../core/database/database_helper.dart';
import 'prescricao_model.dart';

class PrescricaoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Prescricao obj) async {
    final db = await dbHelper.database;
    return db.insert('prescricao', obj.toMap());
  }

  Future<List<Prescricao>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'prescricao',
        where: 'dosagem LIKE ? OR frequencia LIKE ?',
        whereArgs: ['%$search%', '%$search%'],
      );
      return result.map(Prescricao.fromMap).toList();
    }
    final result = await db.query('prescricao', orderBy: 'id_prescricao DESC');
    return result.map(Prescricao.fromMap).toList();
  }

  Future<Prescricao?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prescricao',
      where: 'id_prescricao = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Prescricao.fromMap(result.first);
  }

  Future<List<Prescricao>> findByProntuarioId(int prontuarioId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prescricao',
      where: 'id_prontuario = ?',
      whereArgs: [prontuarioId],
    );
    return result.map(Prescricao.fromMap).toList();
  }

  Future<int> update(Prescricao obj) async {
    final db = await dbHelper.database;
    return db.update(
      'prescricao',
      obj.toMap(),
      where: 'id_prescricao = ?',
      whereArgs: [obj.idPrescricao],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('prescricao', where: 'id_prescricao = ?', whereArgs: [id]);
  }
}
