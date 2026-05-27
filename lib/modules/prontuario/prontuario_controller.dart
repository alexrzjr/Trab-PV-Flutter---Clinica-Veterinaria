import 'prontuario_repository.dart';
import 'prontuario_model.dart';

class ProntuarioController {
  final repository = ProntuarioRepository();

  Future<List<Prontuario>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Prontuario obj) {
    if (obj.id_prontuario == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
