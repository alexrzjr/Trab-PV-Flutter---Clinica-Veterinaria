import 'medicamento_model.dart';
import 'medicamento_repository.dart';

class MedicamentoController {
  final repository = MedicamentoRepository();

  Future<List<Medicamento>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Medicamento?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Medicamento obj) async {
    if (obj.idMedicamento == null) {
      await repository.insert(obj);
    } else {
      await repository.update(obj);
    }
  }

  Future<void> excluir(int id) => repository.delete(id);
}
