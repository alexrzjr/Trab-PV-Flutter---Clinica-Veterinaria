import 'fatura_repository.dart';
import 'fatura_model.dart';

class FaturaController {
  final repository = FaturaRepository();

  Future<List<Fatura>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Fatura obj) {
    if (obj.id_fatura == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
