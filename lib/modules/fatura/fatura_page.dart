import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'fatura_controller.dart';
import 'fatura_model.dart';

class FaturaPage extends StatelessWidget {
  const FaturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FaturaController();
    final lookup = LookupService.instance;

    return CrudScaffold<Fatura>(
      title: 'Fatura',
      subtitle: 'Emissão e controle de faturas dos clientes',
      icon: Icons.request_quote_outlined,
      searchHint: 'Pesquisar por status, data ou ID...',
      idFieldName: 'id_fatura',
      fields: [
        CrudField.dropdown(key: 'id_cliente', label: 'Cliente', required: true, loadOptions: lookup.clientesOptions),
        const CrudField.date(key: 'data_fatura', label: 'Data da fatura', required: true),
        const CrudField.choice(
          key: 'status',
          label: 'Status',
          required: true,
          choices: ['pendente', 'parcial', 'pago', 'cancelado'],
        ),
        const CrudField.multiline(key: 'observacoes', label: 'Observações'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (f) => f.idFatura,
      getTitle: (f) => 'Fatura #${f.idFatura} • R\$ ${f.valorTotal.toStringAsFixed(2)}',
      getSubtitle: (f) => 'Cliente #${f.idCliente} • ${f.dataFatura} • ${f.status}',
      initialValues: (existing) => {
        'id_cliente': existing?.idCliente.toString() ?? '',
        'data_fatura': existing?.dataFatura ?? '',
        'status': existing?.status ?? 'pendente',
        'observacoes': existing?.observacoes ?? '',
      },
      buildItem: (values, existing) => Fatura(
        idFatura: existing?.idFatura,
        idCliente: int.parse(values['id_cliente']!),
        dataFatura: values['data_fatura']!,
        valorTotal: existing?.valorTotal ?? 0,
        status: values['status']!,
        observacoes: values['observacoes'],
      ),
    );
  }
}
