import 'package:flutter/material.dart';
import 'medicamento_controller.dart';
import 'medicamento_model.dart';

class MedicamentoPage extends StatefulWidget {
  const MedicamentoPage({super.key});

  @override
  State<MedicamentoPage> createState() => _MedicamentoPageState();
}

class _MedicamentoPageState extends State<MedicamentoPage> {
  final controller = MedicamentoController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medicamento')),
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
            child: FutureBuilder<List<Medicamento>>(
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
                      title: Text(item.nome.toString()),
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
                              if (item.id_medicamento != null) {
                                await controller.excluir(item.id_medicamento!);
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

  void _form({Medicamento? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['nome'] = TextEditingController(
      text: obj?.nome?.toString() ?? '',
    );
    controllers['lote'] = TextEditingController(
      text: obj?.lote?.toString() ?? '',
    );
    controllers['validade'] = TextEditingController(
      text: obj?.validade?.toString() ?? '',
    );
    controllers['quantidade_estoque'] = TextEditingController(
      text: obj?.quantidade_estoque?.toString() ?? '',
    );
    controllers['tipo'] = TextEditingController(
      text: obj?.tipo?.toString() ?? '',
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
              final novo = Medicamento(
                id_medicamento: obj?.id_medicamento,
                nome: controllers['nome']!.text,
                lote: controllers['lote']!.text,
                validade: controllers['validade']!.text,
                quantidade_estoque: controllers['quantidade_estoque']!.text,
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
