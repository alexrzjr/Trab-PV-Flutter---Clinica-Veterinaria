import '../../core/services/business_rules_service.dart';
import '../../core/services/lookup_service.dart';
import 'prescricao_model.dart';
import 'prescricao_repository.dart';

class PrescricaoController {
  final repository = PrescricaoRepository();
  final _rules = BusinessRulesService.instance;

  Future<List<Prescricao>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Prescricao?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Prescricao obj) async {
    await _rules.validarPrescricao(obj);
    final isNew = obj.idPrescricao == null;
    if (isNew) {
      await repository.insert(obj);
      await _rules.baixarEstoquePrescricao(obj);
    } else {
      await repository.update(obj);
    }
    LookupService.instance.invalidateAll();
  }

  Future<void> excluir(int id) => repository.delete(id);
}
