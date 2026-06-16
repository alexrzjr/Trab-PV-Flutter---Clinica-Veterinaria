import '../../core/database/database_helper.dart';
import 'cliente_model.dart';

class ClienteRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Cliente obj) async {
    final db = await dbHelper.database;
    return db.insert('cliente', obj.toMap());
  }

  Future<List<Cliente>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'cliente',
        where: 'nome LIKE ? OR cpf LIKE ? OR email LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Cliente.fromMap).toList();
    }
    final result = await db.query('cliente', orderBy: 'nome ASC');
    return result.map(Cliente.fromMap).toList();
  }

  Future<Cliente?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'cliente',
      where: 'id_cliente = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Cliente.fromMap(result.first);
  }

  Future<int> update(Cliente obj) async {
    final db = await dbHelper.database;
    return db.update(
      'cliente',
      obj.toMap(),
      where: 'id_cliente = ?',
      whereArgs: [obj.idCliente],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('cliente', where: 'id_cliente = ?', whereArgs: [id]);
  }
}
