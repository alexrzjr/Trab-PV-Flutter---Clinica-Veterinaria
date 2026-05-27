import 'item_fatura_repository.dart';
import 'item_fatura_model.dart';

class Item_faturaController {
  final repository = Item_faturaRepository();

  Future<List<Item_fatura>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar(Item_fatura obj) {
    if (obj.id_item == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
