import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'prescricao_controller.dart';
import 'prescricao_model.dart';

class PrescricaoPage extends StatelessWidget {
  const PrescricaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PrescricaoController();
    final lookup = LookupService.instance;

    return CrudScaffold<Prescricao>(
      title: 'Prescrição',
      subtitle: 'Prescrições médicas com validação de interação e estoque',
      icon: Icons.receipt_long_outlined,
      searchHint: 'Pesquisar por dosagem, frequência ou ID...',
      idFieldName: 'id_prescricao',
      fields: [
        CrudField.dropdown(key: 'id_prontuario', label: 'Prontuário', required: true, loadOptions: lookup.prontuariosOptions),
        CrudField.dropdown(key: 'id_medicamento', label: 'Medicamento', required: true, loadOptions: lookup.medicamentosOptions),
        const CrudField.text(key: 'dosagem', label: 'Dosagem'),
        const CrudField.text(key: 'frequencia', label: 'Frequência'),
        const CrudField.text(key: 'duracao', label: 'Duração'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (p) => p.idPrescricao,
      getTitle: (p) => 'Prescrição #${p.idPrescricao}',
      getSubtitle: (p) => 'Prontuário #${p.idProntuario} • Medicamento #${p.idMedicamento}',
      initialValues: (existing) => {
        'id_prontuario': existing?.idProntuario.toString() ?? '',
        'id_medicamento': existing?.idMedicamento.toString() ?? '',
        'dosagem': existing?.dosagem ?? '',
        'frequencia': existing?.frequencia ?? '',
        'duracao': existing?.duracao ?? '',
      },
      buildItem: (values, existing) => Prescricao(
        idPrescricao: existing?.idPrescricao,
        idProntuario: int.parse(values['id_prontuario']!),
        idMedicamento: int.parse(values['id_medicamento']!),
        dosagem: values['dosagem'],
        frequencia: values['frequencia'],
        duracao: values['duracao'],
      ),
    );
  }
}
