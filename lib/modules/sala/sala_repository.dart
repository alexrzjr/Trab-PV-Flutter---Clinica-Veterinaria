import '../../core/database/database_helper.dart';
import 'sala_model.dart';

class SalaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Sala obj) async {
    final db = await dbHelper.database;
    return db.insert('sala_atendimento', obj.toMap());
  }

  Future<List<Sala>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'sala_atendimento',
        where: 'nome LIKE ?',
        whereArgs: ['%$search%'],
      );
      return result.map(Sala.fromMap).toList();
    }
    final result = await db.query('sala_atendimento', orderBy: 'nome ASC');
    return result.map(Sala.fromMap).toList();
  }

  Future<Sala?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'sala_atendimento',
      where: 'id_sala = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Sala.fromMap(result.first);
  }

  Future<int> update(Sala obj) async {
    final db = await dbHelper.database;
    return db.update(
      'sala_atendimento',
      obj.toMap(),
      where: 'id_sala = ?',
      whereArgs: [obj.idSala],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('sala_atendimento', where: 'id_sala = ?', whereArgs: [id]);
  }
}
