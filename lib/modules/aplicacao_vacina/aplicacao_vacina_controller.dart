import 'aplicacao_vacina_repository.dart';
import 'aplicacao_vacina_model.dart';

class Aplicacao_vacinaController {
  final repository = Aplicacao_vacinaRepository();

  Future<List<Aplicacao_vacina>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Aplicacao_vacina obj) {
    if (obj.id_aplicacao == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
