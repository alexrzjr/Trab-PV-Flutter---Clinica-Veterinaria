import '../../core/services/business_rules_service.dart';
import '../../core/services/lookup_service.dart';
import 'item_fatura_model.dart';
import 'item_fatura_repository.dart';

class ItemFaturaController {
  final repository = ItemFaturaRepository();
  final _rules = BusinessRulesService.instance;

  Future<List<ItemFatura>> listar({String? busca}) => repository.findAll(search: busca);

  Future<ItemFatura?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(ItemFatura obj) async {
    if (obj.idItem == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
    await _rules.recalcularFatura(obj.idFatura);
    LookupService.instance.invalidateAll();
  }

  Future<void> excluir(int id) async {
    final item = await repository.findById(id);
    await repository.delete(id);
    if (item != null) {
      await _rules.recalcularFatura(item.idFatura);
    }
    LookupService.instance.invalidateAll();
  }
}
