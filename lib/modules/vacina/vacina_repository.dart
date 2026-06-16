import '../../core/database/database_helper.dart';
import 'vacina_model.dart';

class VacinaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Vacina obj) async {
    final db = await dbHelper.database;
    return db.insert('vacina', obj.toMap());
  }

  Future<List<Vacina>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'vacina',
        where: 'nome LIKE ?',
        whereArgs: ['%$search%'],
      );
      return result.map(Vacina.fromMap).toList();
    }
    final result = await db.query('vacina', orderBy: 'nome ASC');
    return result.map(Vacina.fromMap).toList();
  }

  Future<Vacina?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'vacina',
      where: 'id_vacina = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Vacina.fromMap(result.first);
  }

  Future<int> update(Vacina obj) async {
    final db = await dbHelper.database;
    return db.update(
      'vacina',
      obj.toMap(),
      where: 'id_vacina = ?',
      whereArgs: [obj.idVacina],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('vacina', where: 'id_vacina = ?', whereArgs: [id]);
  }
}
