import 'cliente_repository.dart';
import 'cliente_model.dart';

class ClienteController {
  final repository = ClienteRepository();

  Future<List<Cliente>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Cliente obj) {
    if (obj.id_cliente == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
