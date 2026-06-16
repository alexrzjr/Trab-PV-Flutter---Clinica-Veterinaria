import '../../core/services/business_rules_service.dart';
import '../../core/services/lookup_service.dart';
import 'pagamento_model.dart';
import 'pagamento_repository.dart';

class PagamentoController {
  final repository = PagamentoRepository();
  final _rules = BusinessRulesService.instance;

  Future<List<Pagamento>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Pagamento?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Pagamento obj) async {
    if (obj.idPagamento == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
    await _rules.atualizarStatusFaturaPorPagamentos(obj.idFatura);
    LookupService.instance.invalidateAll();
  }

  Future<void> excluir(int id) async {
    final pag = await repository.findById(id);
    await repository.delete(id);
    if (pag != null) {
      await _rules.atualizarStatusFaturaPorPagamentos(pag.idFatura);
    }
    LookupService.instance.invalidateAll();
  }
}
