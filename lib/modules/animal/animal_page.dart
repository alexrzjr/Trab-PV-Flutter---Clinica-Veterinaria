import 'package:flutter/material.dart';
import 'animal_controller.dart';
import 'animal_model.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  final controller = AnimalController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Pesquisar'),
              onChanged: (v) => setState(() => busca = v),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Animal>>(
              future: controller.listar(busca: busca),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lista = snapshot.data!;
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final item = lista[i];
                    return ListTile(
                      title: Text(item.id_cliente.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _form(obj: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (item.id_animal != null) {
                                await controller.excluir(item.id_animal!);
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _form({Animal? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_cliente'] = TextEditingController(
      text: obj?.id_cliente?.toString() ?? '',
    );
    controllers['nome'] = TextEditingController(
      text: obj?.nome?.toString() ?? '',
    );
    controllers['especie'] = TextEditingController(
      text: obj?.especie?.toString() ?? '',
    );
    controllers['raca'] = TextEditingController(
      text: obj?.raca?.toString() ?? '',
    );
    controllers['sexo'] = TextEditingController(
      text: obj?.sexo?.toString() ?? '',
    );
    controllers['data_nascimento'] = TextEditingController(
      text: obj?.data_nascimento?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cadastro'),
        content: SingleChildScrollView(
          child: Column(
            children: controllers.entries.map((e) {
              return TextField(
                controller: e.value,
                decoration: InputDecoration(labelText: e.key),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final novo = Animal(
                id_animal: obj?.id_animal,
                id_cliente: int.parse(controllers['id_cliente']!.text),
                nome: controllers['nome']!.text,
                especie: controllers['especie']!.text,
                raca: controllers['raca']!.text,
                sexo: controllers['sexo']!.text,
                data_nascimento: controllers['data_nascimento']!.text,
              );
              await controller.salvar(novo);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
