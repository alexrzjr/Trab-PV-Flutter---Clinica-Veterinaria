import 'profissional_model.dart';
import 'profissional_repository.dart';

class ProfissionalController {
  final repository = ProfissionalRepository();

  Future<List<Profissional>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Profissional?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Profissional obj) async {
    if (obj.idProfissional == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
  }

  Future<void> excluir(int id) => repository.delete(id);
}
