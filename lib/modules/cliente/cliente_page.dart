import 'package:flutter/material.dart';
import 'cliente_controller.dart';
import 'cliente_model.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final controller = ClienteController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cliente')),
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
            child: FutureBuilder<List<Cliente>>(
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
                              if (item.id_cliente != null){
                                await controller.excluir(item.id_cliente!);
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

  void _form({Cliente? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['nome'] = TextEditingController(text: obj?.nome?.toString() ?? '');
    controllers['cpf'] = TextEditingController(text: obj?.cpf?.toString() ?? '');
    controllers['telefone'] = TextEditingController(text: obj?.telefone?.toString() ?? '');
    controllers['email'] = TextEditingController(text: obj?.email?.toString() ?? '');
    controllers['endereco'] = TextEditingController(text: obj?.endereco?.toString() ?? '');
    controllers['observacoes'] = TextEditingController(text: obj?.observacoes?.toString() ?? '');

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
              final novo = Cliente(
                id_cliente: obj?.id_cliente,
                nome: controllers['nome']!.text,
                cpf: controllers['cpf']!.text,
                telefone: controllers['telefone']!.text,
                email: controllers['email']!.text,
                endereco: controllers['endereco']!.text,
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
