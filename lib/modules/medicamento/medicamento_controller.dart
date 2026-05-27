import 'medicamento_repository.dart';
import 'medicamento_model.dart';

class MedicamentoController {
  final repository = MedicamentoRepository();

  Future<List<Medicamento>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Medicamento obj) {
    if (obj.id_medicamento == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
