import '../../core/database/database_helper.dart';
import 'usuario_model.dart';

class UsuarioRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<Usuario?> findByEmail(String email) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'usuario',
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Usuario.fromMap(result.first);
  }

  Future<Usuario?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'usuario',
      where: 'id_usuario = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Usuario.fromMap(result.first);
  }
}
