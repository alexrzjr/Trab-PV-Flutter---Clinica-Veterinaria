import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'item_fatura_controller.dart';
import 'item_fatura_model.dart';

class ItemFaturaPage extends StatelessWidget {
  const ItemFaturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ItemFaturaController();
    final lookup = LookupService.instance;

    return CrudScaffold<ItemFatura>(
      title: 'Item de Fatura',
      subtitle: 'Procedimentos, medicamentos e produtos faturados',
      icon: Icons.list_alt_outlined,
      searchHint: 'Pesquisar por descrição ou ID...',
      idFieldName: 'id_item',
      fields: [
        CrudField.dropdown(key: 'id_fatura', label: 'Fatura', required: true, loadOptions: lookup.faturasOptions),
        const CrudField.text(key: 'descricao', label: 'Descrição', required: true),
        const CrudField.number(key: 'valor', label: 'Valor (R\$)', required: true),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (i) => i.idItem,
      getTitle: (i) => i.descricao,
      getSubtitle: (i) => 'Fatura #${i.idFatura} • R\$ ${i.valor.toStringAsFixed(2)}',
      initialValues: (existing) => {
        'id_fatura': existing?.idFatura.toString() ?? '',
        'descricao': existing?.descricao ?? '',
        'valor': existing?.valor.toStringAsFixed(2) ?? '',
      },
      buildItem: (values, existing) => ItemFatura(
        idItem: existing?.idItem,
        idFatura: int.parse(values['id_fatura']!),
        descricao: values['descricao']!,
        valor: double.parse(values['valor']!.replaceAll(',', '.')),
      ),
    );
  }
}
