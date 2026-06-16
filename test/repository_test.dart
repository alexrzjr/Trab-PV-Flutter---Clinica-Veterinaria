import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:clinica_veterinaria/core/database/database_helper.dart';
import 'package:clinica_veterinaria/modules/cliente/cliente_model.dart';
import 'package:clinica_veterinaria/modules/cliente/cliente_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('Cliente insert e findById', () async {
    await DatabaseHelper.instance.database;
    final repo = ClienteRepository();

    final id = await repo.insert(Cliente(
      nome: 'Teste Unitário',
      cpf: '39053344705',
      telefone: '11999999999',
    ));

    final found = await repo.findById(id);
    expect(found, isNotNull);
    expect(found!.nome, 'Teste Unitário');
  });
}
