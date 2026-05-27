import 'prescricao_repository.dart';
import 'prescricao_model.dart';

class PrescricaoController {
  final repository = PrescricaoRepository();

  Future<List<Prescricao>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Prescricao obj) {
    if (obj.id_prescricao == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
