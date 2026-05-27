import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import 'cliente_model.dart';

class ClienteRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Cliente obj) async {
    final db = await dbHelper.database;
    return await db.insert('cliente', obj.toMap());
  }

  Future<List<Cliente>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'cliente',
      where: search != null && search.isNotEmpty
          ? 'nome LIKE ?'
          : null,
      whereArgs: search != null && search.isNotEmpty
          ? ['%$search%']
          : null,
    );
    return result.map((e) => Cliente.fromMap(e)).toList();
  }

  Future<int> update(Cliente obj) async {
    final db = await dbHelper.database;
    return await db.update(
      'cliente',
      obj.toMap(),
      where: 'id_cliente = ?',
      whereArgs: [obj.id_cliente],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'cliente',
      where: 'id_cliente = ?',
      whereArgs: [id],
    );
  }
}
