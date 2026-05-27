import 'package:flutter/material.dart';
import 'profissional_controller.dart';
import 'profissional_model.dart';

class ProfissionalPage extends StatefulWidget {
  const ProfissionalPage({super.key});

  @override
  State<ProfissionalPage> createState() => _ProfissionalPageState();
}

class _ProfissionalPageState extends State<ProfissionalPage> {
  final controller = ProfissionalController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profissional')),
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
            child: FutureBuilder<List<Profissional>>(
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
                              if (item.id_profissional != null){
                                await controller.excluir(item.id_profissional!);
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

  void _form({Profissional? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['nome'] = TextEditingController(text: obj?.nome?.toString() ?? '');
    controllers['especialidade'] = TextEditingController(text: obj?.especialidade?.toString() ?? '');
    controllers['crmv'] = TextEditingController(text: obj?.crmv?.toString() ?? '');

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
              final novo = Profissional(
                id_profissional: obj?.id_profissional,
                nome: controllers['nome']!.text,
                especialidade: controllers['especialidade']!.text,
                crmv: controllers['crmv']!.text,
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
