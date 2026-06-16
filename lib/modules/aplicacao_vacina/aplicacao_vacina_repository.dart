import '../../core/database/database_helper.dart';
import 'aplicacao_vacina_model.dart';

class AplicacaoVacinaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(AplicacaoVacina obj) async {
    final db = await dbHelper.database;
    return db.insert('aplicacao_vacina', obj.toMap());
  }

  Future<List<AplicacaoVacina>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'aplicacao_vacina',
        where: 'data_aplicacao LIKE ? OR data_reforco LIKE ?',
        whereArgs: ['%$search%', '%$search%'],
      );
      return result.map(AplicacaoVacina.fromMap).toList();
    }
    final result = await db.query('aplicacao_vacina', orderBy: 'data_aplicacao DESC');
    return result.map(AplicacaoVacina.fromMap).toList();
  }

  Future<AplicacaoVacina?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'aplicacao_vacina',
      where: 'id_aplicacao = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return AplicacaoVacina.fromMap(result.first);
  }

  Future<int> update(AplicacaoVacina obj) async {
    final db = await dbHelper.database;
    return db.update(
      'aplicacao_vacina',
      obj.toMap(),
      where: 'id_aplicacao = ?',
      whereArgs: [obj.idAplicacao],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('aplicacao_vacina', where: 'id_aplicacao = ?', whereArgs: [id]);
  }
}
