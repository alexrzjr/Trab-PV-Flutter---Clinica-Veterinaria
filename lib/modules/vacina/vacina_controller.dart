import 'vacina_repository.dart';
import 'vacina_model.dart';

class VacinaController {
  final repository = VacinaRepository();

  Future<List<Vacina>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Vacina obj) {
    if (obj.id_vacina == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
