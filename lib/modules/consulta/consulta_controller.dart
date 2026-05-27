import 'consulta_repository.dart';
import 'consulta_model.dart';

class ConsultaController {
  final repository = ConsultaRepository();

  Future<List<Consulta>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Consulta obj) {
    if (obj.id_consulta == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
