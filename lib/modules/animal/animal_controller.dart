import 'animal_repository.dart';
import 'animal_model.dart';

class AnimalController {
  final repository = AnimalRepository();

  Future<List<Animal>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Animal obj) {
    if (obj.id_animal == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
