import '../../core/database/database_helper.dart';
import 'consulta_model.dart';

class ConsultaRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Consulta obj) async {
    final db = await dbHelper.database;
    return db.insert('consulta', obj.toMap());
  }

  Future<List<Consulta>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'consulta',
        where: 'status LIKE ? OR tipo LIKE ? OR data_hora LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Consulta.fromMap).toList();
    }
    final result = await db.query('consulta', orderBy: 'data_hora DESC');
    return result.map(Consulta.fromMap).toList();
  }

  Future<Consulta?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'consulta',
      where: 'id_consulta = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Consulta.fromMap(result.first);
  }

  Future<int> update(Consulta obj) async {
    final db = await dbHelper.database;
    return db.update(
      'consulta',
      obj.toMap(),
      where: 'id_consulta = ?',
      whereArgs: [obj.idConsulta],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('consulta', where: 'id_consulta = ?', whereArgs: [id]);
  }

  Future<List<Consulta>> findConflicts(Consulta obj) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      '''
      SELECT * FROM consulta
      WHERE data_hora = ?
        AND status != 'cancelada'
        AND id_consulta != ?
        AND (
          id_profissional = ?
          OR (? IS NOT NULL AND id_sala = ?)
        )
      ''',
      [
        obj.dataHora,
        obj.idConsulta ?? 0,
        obj.idProfissional,
        obj.idSala,
        obj.idSala,
      ],
    );
    return result.map(Consulta.fromMap).toList();
  }

  Future<List<Consulta>> findByDate(String datePrefix) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'consulta',
      where: 'data_hora LIKE ? AND status != ?',
      whereArgs: ['$datePrefix%', 'cancelada'],
      orderBy: 'data_hora ASC',
    );
    return result.map(Consulta.fromMap).toList();
  }

  Future<void> marcarLembreteEnviado(int id) async {
    final db = await dbHelper.database;
    await db.update(
      'consulta',
      {'lembrete_enviado': 1},
      where: 'id_consulta = ?',
      whereArgs: [id],
    );
  }
}
