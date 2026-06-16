import '../../core/services/lookup_service.dart';
import 'prontuario_model.dart';
import 'prontuario_repository.dart';

class ProntuarioController {
  final repository = ProntuarioRepository();

  Future<List<Prontuario>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Prontuario?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Prontuario obj) async {
    if (obj.idProntuario == null) {
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
