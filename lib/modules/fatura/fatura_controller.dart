import '../../core/services/lookup_service.dart';
import 'fatura_model.dart';
import 'fatura_repository.dart';

class FaturaController {
  final repository = FaturaRepository();

  Future<List<Fatura>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Fatura?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Fatura obj) async {
    if (obj.idFatura == null) {
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
