import '../../core/database/database_helper.dart';
import 'profissional_model.dart';

class ProfissionalRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Profissional obj) async {
    final db = await dbHelper.database;
    return db.insert('profissional', obj.toMap());
  }

  Future<List<Profissional>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'profissional',
        where: 'nome LIKE ? OR especialidade LIKE ? OR crmv LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Profissional.fromMap).toList();
    }
    final result = await db.query('profissional', orderBy: 'nome ASC');
    return result.map(Profissional.fromMap).toList();
  }

  Future<Profissional?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'profissional',
      where: 'id_profissional = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Profissional.fromMap(result.first);
  }

  Future<int> update(Profissional obj) async {
    final db = await dbHelper.database;
    return db.update(
      'profissional',
      obj.toMap(),
      where: 'id_profissional = ?',
      whereArgs: [obj.idProfissional],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('profissional', where: 'id_profissional = ?', whereArgs: [id]);
  }
}
