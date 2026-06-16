import '../../core/services/lookup_service.dart';
import 'cliente_model.dart';
import 'cliente_repository.dart';

class ClienteController {
  final repository = ClienteRepository();

  Future<List<Cliente>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Cliente?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Cliente obj) async {
    if (obj.idCliente == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
    LookupService.instance.invalidateAll();
  }

  Future<void> excluir(int id) async {
    await repository.delete(id);
    LookupService.instance.invalidateAll();
  }
}
