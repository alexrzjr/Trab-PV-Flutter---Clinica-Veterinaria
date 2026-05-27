import 'package:flutter/material.dart';
import 'prontuario_controller.dart';
import 'prontuario_model.dart';

class ProntuarioPage extends StatefulWidget {
  const ProntuarioPage({super.key});

  @override
  State<ProntuarioPage> createState() => _ProntuarioPageState();
}

class _ProntuarioPageState extends State<ProntuarioPage> {
  final controller = ProntuarioController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prontuario')),
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
            child: FutureBuilder<List<Prontuario>>(
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
                              if (item.id_prontuario != null) {
                                await controller.excluir(item.id_prontuario!);
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

  void _form({Prontuario? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_animal'] = TextEditingController(
      text: obj?.id_animal?.toString() ?? '',
    );
    controllers['id_consulta'] = TextEditingController(
      text: obj?.id_consulta?.toString() ?? '',
    );
    controllers['data_registro'] = TextEditingController(
      text: obj?.data_registro?.toString() ?? '',
    );
    controllers['diagnostico'] = TextEditingController(
      text: obj?.diagnostico?.toString() ?? '',
    );
    controllers['observacoes'] = TextEditingController(
      text: obj?.observacoes?.toString() ?? '',
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
              final novo = Prontuario(
                id_prontuario: obj?.id_prontuario,
                id_animal: int.parse(controllers['id_animal']!.text),
                id_consulta: int.parse(controllers['id_consulta']!.text),
                data_registro: controllers['data_registro']!.text,
                diagnostico: controllers['diagnostico']!.text,
                observacoes: controllers['observacoes']!.text,
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
