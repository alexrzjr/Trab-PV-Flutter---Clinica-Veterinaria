import '../../core/services/lookup_service.dart';
import 'animal_model.dart';
import 'animal_repository.dart';

class AnimalController {
  final repository = AnimalRepository();

  Future<List<Animal>> listar({String? busca}) => repository.findAll(search: busca);

  Future<Animal?> buscarPorId(int id) => repository.findById(id);

  Future<void> salvar(Animal obj) async {
    if (obj.idAnimal == null) {
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
