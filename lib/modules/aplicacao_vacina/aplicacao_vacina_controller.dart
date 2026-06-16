import '../../core/services/lookup_service.dart';
import 'aplicacao_vacina_model.dart';
import 'aplicacao_vacina_repository.dart';

class AplicacaoVacinaController {
  final repository = AplicacaoVacinaRepository();

  Future<List<AplicacaoVacina>> listar({String? busca}) => repository.findAll(search: busca);

  Future<AplicacaoVacina?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(AplicacaoVacina obj) async {
    if (obj.idAplicacao == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
    LookupService.instance.invalidateAll();
  }

  Future<void> excluir(int id) => repository.delete(id);
}
