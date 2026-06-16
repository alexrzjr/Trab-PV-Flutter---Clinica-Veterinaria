import '../../core/database/database_helper.dart';

class AlertasService {
  AlertasService._();
  static final AlertasService instance = AlertasService._();

  final _db = DatabaseHelper.instance;

  Future<List<Map<String, dynamic>>> medicamentosEstoqueBaixo() async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT * FROM medicamento WHERE quantidade_estoque <= estoque_minimo ORDER BY quantidade_estoque ASC',
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> vacinasReforcoProximo({int dias = 30}) async {
    final db = await _db.database;
    final limite = DateTime.now().add(Duration(days: dias));
    final limiteStr =
        '${limite.year}-${limite.month.toString().padLeft(2, '0')}-${limite.day.toString().padLeft(2, '0')}';
    final hoje = DateTime.now();
    final hojeStr =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';

    final result = await db.rawQuery(
      '''
      SELECT av.*, v.nome as nome_vacina
      FROM aplicacao_vacina av
      JOIN vacina v ON v.id_vacina = av.id_vacina
      WHERE av.data_reforco IS NOT NULL
        AND av.data_reforco >= ?
        AND av.data_reforco <= ?
      ORDER BY av.data_reforco ASC
      ''',
      [hojeStr, limiteStr],
    );
    return result;
  }

  Future<int> countAlertas() async {
    final estoque = await medicamentosEstoqueBaixo();
    final vacinas = await vacinasReforcoProximo();
    return estoque.length + vacinas.length;
  }
}
