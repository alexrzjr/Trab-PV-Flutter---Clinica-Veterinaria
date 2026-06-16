import 'sala_model.dart';
import 'sala_repository.dart';

class SalaController {
  final repository = SalaRepository();

  Future<List<Sala>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Sala?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Sala obj) async {
    if (obj.idSala == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
  }

  Future<void> excluir(int id) => repository.delete(id);
}
