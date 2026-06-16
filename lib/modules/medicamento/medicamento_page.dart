import 'package:flutter/material.dart';

import '../../core/widgets/crud_scaffold.dart';
import 'medicamento_controller.dart';
import 'medicamento_model.dart';

class MedicamentoPage extends StatelessWidget {
  const MedicamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MedicamentoController();

    return CrudScaffold<Medicamento>(
      title: 'Medicamento',
      subtitle: 'Controle de estoque e alertas de interação',
      icon: Icons.medication_outlined,
      searchHint: 'Pesquisar por nome, tipo, lote ou ID...',
      idFieldName: 'id_medicamento',
      fields: const [
        CrudField(key: 'nome', label: 'Nome', required: true),
        CrudField(key: 'lote', label: 'Lote'),
        CrudField(key: 'validade', label: 'Validade (AAAA-MM-DD)'),
        CrudField(
          key: 'quantidade_estoque',
          label: 'Quantidade em estoque',
          keyboardType: TextInputType.number,
        ),
        CrudField(
          key: 'estoque_minimo',
          label: 'Estoque mínimo',
          keyboardType: TextInputType.number,
        ),
        CrudField(key: 'tipo', label: 'Tipo'),
        CrudField(key: 'alerta_interacao', label: 'Alerta de interação'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (m) => m.idMedicamento,
      getTitle: (m) => m.nome,
      getSubtitle: (m) {
        final alerta = m.estoqueBaixo ? ' ⚠ Estoque baixo' : '';
        return 'Estoque: ${m.quantidadeEstoque} • ${m.tipo ?? 'Sem tipo'}$alerta';
      },
      initialValues: (existing) => {
        'nome': existing?.nome ?? '',
        'lote': existing?.lote ?? '',
        'validade': existing?.validade ?? '',
        'quantidade_estoque': existing?.quantidadeEstoque.toString() ?? '0',
        'estoque_minimo': existing?.estoqueMinimo.toString() ?? '5',
        'tipo': existing?.tipo ?? '',
        'alerta_interacao': existing?.alertaInteracao ?? '',
      },
      buildItem: (values, existing) => Medicamento(
        idMedicamento: existing?.idMedicamento,
        nome: values['nome']!,
        lote: values['lote'],
        validade: values['validade'],
        quantidadeEstoque:
            int.tryParse(values['quantidade_estoque'] ?? '') ?? 0,
        estoqueMinimo: int.tryParse(values['estoque_minimo'] ?? '') ?? 5,
        tipo: values['tipo'],
        alertaInteracao: values['alerta_interacao'],
      ),
    );
  }
}
