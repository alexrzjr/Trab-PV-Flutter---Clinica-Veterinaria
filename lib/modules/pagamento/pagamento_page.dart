import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'pagamento_controller.dart';
import 'pagamento_model.dart';

class PagamentoPage extends StatelessWidget {
  const PagamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PagamentoController();
    final lookup = LookupService.instance;

    return CrudScaffold<Pagamento>(
      title: 'Pagamento',
      subtitle: 'Registro de pagamentos e contas a receber',
      icon: Icons.payments_outlined,
      searchHint: 'Pesquisar por forma, data ou ID...',
      idFieldName: 'id_pagamento',
      fields: [
        CrudField.dropdown(key: 'id_fatura', label: 'Fatura', required: true, loadOptions: lookup.faturasOptions),
        const CrudField.date(key: 'data_pagamento', label: 'Data do pagamento', required: true),
        const CrudField.number(key: 'valor', label: 'Valor (R\$)', required: true),
        const CrudField.choice(
          key: 'forma_pagamento',
          label: 'Forma de pagamento',
          required: true,
          choices: ['PIX', 'Dinheiro', 'Cartão de crédito', 'Cartão de débito', 'Transferência'],
        ),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (p) => p.idPagamento,
      getTitle: (p) => 'Pagamento #${p.idPagamento} • R\$ ${p.valor.toStringAsFixed(2)}',
      getSubtitle: (p) => 'Fatura #${p.idFatura} • ${p.formaPagamento} • ${p.dataPagamento}',
      initialValues: (existing) => {
        'id_fatura': existing?.idFatura.toString() ?? '',
        'data_pagamento': existing?.dataPagamento ?? '',
        'valor': existing?.valor.toStringAsFixed(2) ?? '',
        'forma_pagamento': existing?.formaPagamento ?? 'PIX',
      },
      buildItem: (values, existing) => Pagamento(
        idPagamento: existing?.idPagamento,
        idFatura: int.parse(values['id_fatura']!),
        dataPagamento: values['data_pagamento']!,
        valor: double.parse(values['valor']!.replaceAll(',', '.')),
        formaPagamento: values['forma_pagamento']!,
      ),
    );
  }
}
