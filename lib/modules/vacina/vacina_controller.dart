import 'vacina_model.dart';
import 'vacina_repository.dart';

class VacinaController {
  final repository = VacinaRepository();

  Future<List<Vacina>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Vacina?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Vacina obj) async {
    if (obj.idVacina == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
  }

  Future<void> excluir(int id) => repository.delete(id);
}
