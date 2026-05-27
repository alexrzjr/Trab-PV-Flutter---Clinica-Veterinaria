import 'profissional_repository.dart';
import 'profissional_model.dart';

class ProfissionalController {
  final repository = ProfissionalRepository();

  Future<List<Profissional>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Profissional obj) {
    if (obj.id_profissional == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
