import 'package:flutter/material.dart';
import 'aplicacao_vacina_controller.dart';
import 'aplicacao_vacina_model.dart';

class Aplicacao_vacinaPage extends StatefulWidget {
  const Aplicacao_vacinaPage({super.key});

  @override
  State<Aplicacao_vacinaPage> createState() => _Aplicacao_vacinaPageState();
}

class _Aplicacao_vacinaPageState extends State<Aplicacao_vacinaPage> {
  final controller = Aplicacao_vacinaController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicacao_vacina')),
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
            child: FutureBuilder<List<Aplicacao_vacina>>(
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
                              if (item.id_aplicacao != null){
                                await controller.excluir(item.id_aplicacao!);
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

  void _form({Aplicacao_vacina? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_prontuario'] = TextEditingController(text: obj?.id_prontuario?.toString() ?? '');
    controllers['id_vacina'] = TextEditingController(text: obj?.id_vacina?.toString() ?? '');
    controllers['data_aplicacao'] = TextEditingController(text: obj?.data_aplicacao?.toString() ?? '');
    controllers['data_reforco'] = TextEditingController(text: obj?.data_reforco?.toString() ?? '');

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
              final novo = Aplicacao_vacina(
                id_aplicacao: obj?.id_aplicacao,
                id_prontuario: int.parse(controllers['id_prontuario']!.text),
                id_vacina: int.parse(controllers['id_vacina']!.text),
                data_aplicacao: controllers['data_aplicacao']!.text,
                data_reforco: controllers['data_reforco']!.text,
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
