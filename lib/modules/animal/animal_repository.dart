import '../../core/database/database_helper.dart';
import 'animal_model.dart';

class AnimalRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Animal obj) async {
    final db = await dbHelper.database;
    return db.insert('animal', obj.toMap());
  }

  Future<List<Animal>> findAll({String? search}) async {
    final db = await dbHelper.database;
    if (search != null && search.isNotEmpty) {
      final id = int.tryParse(search);
      if (id != null) {
        final byId = await findById(id);
        return byId != null ? [byId] : [];
      }
      final result = await db.query(
        'animal',
        where: 'nome LIKE ? OR especie LIKE ? OR raca LIKE ?',
        whereArgs: ['%$search%', '%$search%', '%$search%'],
      );
      return result.map(Animal.fromMap).toList();
    }
    final result = await db.query('animal', orderBy: 'nome ASC');
    return result.map(Animal.fromMap).toList();
  }

  Future<Animal?> findById(int id) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'animal',
      where: 'id_animal = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Animal.fromMap(result.first);
  }

  Future<List<Animal>> findByClienteId(int clienteId) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'animal',
      where: 'id_cliente = ?',
      whereArgs: [clienteId],
    );
    return result.map(Animal.fromMap).toList();
  }

  Future<int> update(Animal obj) async {
    final db = await dbHelper.database;
    return db.update(
      'animal',
      obj.toMap(),
      where: 'id_animal = ?',
      whereArgs: [obj.idAnimal],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return db.delete('animal', where: 'id_animal = ?', whereArgs: [id]);
  }
}
