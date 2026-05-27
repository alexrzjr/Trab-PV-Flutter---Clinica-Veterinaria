import 'package:flutter/material.dart';
import 'item_fatura_controller.dart';
import 'item_fatura_model.dart';

class Item_faturaPage extends StatefulWidget {
  const Item_faturaPage({super.key});

  @override
  State<Item_faturaPage> createState() => _Item_faturaPageState();
}

class _Item_faturaPageState extends State<Item_faturaPage> {
  final controller = Item_faturaController();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item_fatura')),
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
            child: FutureBuilder<List<Item_fatura>>(
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
                      title: Text(item.id_fatura.toString()),
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
                              if (item.id_item != null){
                                await controller.excluir(item.id_item!);
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

  void _form({Item_fatura? obj}) {
    final controllers = <String, TextEditingController>{};
    controllers['id_fatura'] = TextEditingController(text: obj?.id_fatura?.toString() ?? '');
    controllers['descricao'] = TextEditingController(text: obj?.descricao?.toString() ?? '');
    controllers['valor'] = TextEditingController(text: obj?.valor?.toString() ?? '');

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
              final novo = Item_fatura(
                id_item: obj?.id_item,
                id_fatura: int.parse(controllers['id_fatura']!.text),
                descricao: controllers['descricao']!.text,
                valor: controllers['valor']!.text,
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
