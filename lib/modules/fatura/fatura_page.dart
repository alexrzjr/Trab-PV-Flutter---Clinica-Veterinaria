import 'package:flutter/material.dart';
import 'fatura_controller.dart';
import 'fatura_model.dart';

class FaturaPage extends StatefulWidget {
  const FaturaPage({super.key});

  @override
  State<FaturaPage> createState() => _FaturaPageState();
}

class _FaturaPageState extends State<FaturaPage> {
  final controller = FaturaController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fatura')),
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
            child: FutureBuilder<List<Fatura>>(
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
                              if (item.id_fatura != null){
                              await controller.excluir(item.id_fatura!);
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

  void _form({Fatura? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_cliente'] = TextEditingController(text: obj?.id_cliente?.toString() ?? '');
    controllers['data_fatura'] = TextEditingController(text: obj?.data_fatura?.toString() ?? '');
    controllers['valor_total'] = TextEditingController(text: obj?.valor_total?.toString() ?? '');
    controllers['status'] = TextEditingController(text: obj?.status?.toString() ?? '');

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
              final novo = Fatura(
                id_fatura: obj?.id_fatura,
                id_cliente: int.parse(controllers['id_cliente']!.text),
                data_fatura: controllers['data_fatura']!.text,
                valor_total: controllers['valor_total']!.text,
                status: controllers['status']!.text,
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
