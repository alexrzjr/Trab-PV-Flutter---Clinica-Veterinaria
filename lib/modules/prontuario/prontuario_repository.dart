import '../../core/database/database_helper.dart';
import 'prontuario_model.dart';

class ProntuarioRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Prontuario obj) async {
    final db = await dbHelper.database;
    return db.insert('prontuario', obj.toMap());
  }

  Future<List<Prontuario>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'prontuario',
        where: 'diagnostico LIKE ? OR observacoes LIKE ? OR data_registro LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Prontuario.fromMap).toList();
    }
    final result = await db.query('prontuario', orderBy: 'data_registro DESC');
    return result.map(Prontuario.fromMap).toList();
  }

  Future<Prontuario?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prontuario',
      where: 'id_prontuario = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Prontuario.fromMap(result.first);
  }

  Future<List<Prontuario>> findByAnimalId(int animalId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'prontuario',
      where: 'id_animal = ?',
      whereArgs: [animalId],
    );
    return result.map(Prontuario.fromMap).toList();
  }

  Future<int> update(Prontuario obj) async {
    final db = await dbHelper.database;
    return db.update(
      'prontuario',
      obj.toMap(),
      where: 'id_prontuario = ?',
      whereArgs: [obj.idProntuario],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('prontuario', where: 'id_prontuario = ?', whereArgs: [id]);
  }
}
