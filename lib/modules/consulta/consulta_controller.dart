import 'consulta_model.dart';
import 'consulta_repository.dart';
import '../../core/services/business_rules_service.dart';
import '../../core/services/lookup_service.dart';

class ConsultaController {
  final repository = ConsultaRepository();
  final _rules = BusinessRulesService.instance;

  Future<List<Consulta>> listar({String? busca}) => repository.findAll(search: busca);

  Future<List<Consulta>> listarHoje() async {
    final now = DateTime.now();
    final prefix =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return repository.findByDate(prefix);
  }

  Future<Consulta?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Consulta obj) async {
    await _rules.validarConsulta(obj);
    if (obj.idConsulta == null) {
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

  Future<void> enviarLembrete(int id) async {
    await repository.marcarLembreteEnviado(id);
  }
}
