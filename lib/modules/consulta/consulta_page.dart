import 'package:flutter/material.dart';
import 'consulta_controller.dart';
import 'consulta_model.dart';

class ConsultaPage extends StatefulWidget {
  const ConsultaPage({super.key});

  @override
  State<ConsultaPage> createState() => _ConsultaPageState();
}

class _ConsultaPageState extends State<ConsultaPage> {
  final controller = ConsultaController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta')),
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
            child: FutureBuilder<List<Consulta>>(
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
                      title: Text(item.id_animal.toString()),
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
                              if (item.id_consulta != null){
                                await controller.excluir(item.id_consulta!);
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

  void _form({Consulta? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_animal'] = TextEditingController(text: obj?.id_animal?.toString() ?? '');
    controllers['id_profissional'] = TextEditingController(text: obj?.id_profissional?.toString() ?? '');
    controllers['data_hora'] = TextEditingController(text: obj?.data_hora?.toString() ?? '');
    controllers['status'] = TextEditingController(text: obj?.status?.toString() ?? '');
    controllers['tipo'] = TextEditingController(text: obj?.tipo?.toString() ?? '');

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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final novo = Consulta(
                id_consulta: obj?.id_consulta,
                id_animal: int.parse(controllers['id_animal']!.text),
                id_profissional: int.parse(controllers['id_profissional']!.text),
                data_hora: controllers['data_hora']!.text,
                status: controllers['status']!.text,
                tipo: controllers['tipo']!.text,
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
