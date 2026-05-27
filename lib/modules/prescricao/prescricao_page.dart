import 'package:flutter/material.dart';
import 'prescricao_controller.dart';
import 'prescricao_model.dart';

class PrescricaoPage extends StatefulWidget {
  const PrescricaoPage({super.key});

  @override
  State<PrescricaoPage> createState() => _PrescricaoPageState();
}

class _PrescricaoPageState extends State<PrescricaoPage> {
  final controller = PrescricaoController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescricao')),
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
            child: FutureBuilder<List<Prescricao>>(
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
                      title: Text(item.id_prontuario.toString()),
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
                              if (item.id_prescricao != null) {
                                await controller.excluir(item.id_prescricao!);
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

  void _form({Prescricao? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_prontuario'] = TextEditingController(
      text: obj?.id_prontuario?.toString() ?? '',
    );
    controllers['id_medicamento'] = TextEditingController(
      text: obj?.id_medicamento?.toString() ?? '',
    );
    controllers['dosagem'] = TextEditingController(
      text: obj?.dosagem?.toString() ?? '',
    );
    controllers['frequencia'] = TextEditingController(
      text: obj?.frequencia?.toString() ?? '',
    );
    controllers['duracao'] = TextEditingController(
      text: obj?.duracao?.toString() ?? '',
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
              final novo = Prescricao(
                id_prescricao: obj?.id_prescricao,
                id_prontuario: int.parse(controllers['id_prontuario']!.text),
                id_medicamento: int.parse(controllers['id_medicamento']!.text),
                dosagem: controllers['dosagem']!.text,
                frequencia: controllers['frequencia']!.text,
                duracao: controllers['duracao']!.text,
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
