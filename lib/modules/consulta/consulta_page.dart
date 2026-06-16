import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'consulta_controller.dart';
import 'consulta_model.dart';

class ConsultaPage extends StatelessWidget {
  const ConsultaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ConsultaController();
    final lookup = LookupService.instance;

    return CrudScaffold<Consulta>(
      title: 'Consulta',
      subtitle: 'Agendamento de consultas e procedimentos',
      icon: Icons.calendar_month_outlined,
      searchHint: 'Pesquisar por status, tipo, data ou ID...',
      idFieldName: 'id_consulta',
      fields: [
        CrudField.dropdown(key: 'id_animal', label: 'Animal', required: true, loadOptions: lookup.animaisOptions),
        CrudField.dropdown(key: 'id_profissional', label: 'Profissional', required: true, loadOptions: lookup.profissionaisOptions),
        CrudField.dropdown(key: 'id_sala', label: 'Sala', loadOptions: lookup.salasOptions),
        const CrudField.datetime(key: 'data_hora', label: 'Data e hora', required: true),
        const CrudField.choice(
          key: 'status',
          label: 'Status',
          required: true,
          choices: ['agendada', 'confirmada', 'concluida', 'cancelada'],
        ),
        const CrudField.choice(
          key: 'tipo',
          label: 'Tipo',
          choices: ['consulta', 'cirurgia', 'procedimento', 'vacina'],
        ),
        const CrudField.multiline(key: 'observacoes', label: 'Observações'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (c) => c.idConsulta,
      getTitle: (c) => '${c.tipo ?? 'Consulta'} • ${c.dataHora}',
      getSubtitle: (c) => 'Animal #${c.idAnimal} • ${c.status}',
      initialValues: (existing) => {
        'id_animal': existing?.idAnimal.toString() ?? '',
        'id_profissional': existing?.idProfissional.toString() ?? '',
        'id_sala': existing?.idSala?.toString() ?? '',
        'data_hora': existing?.dataHora ?? '',
        'status': existing?.status ?? 'agendada',
        'tipo': existing?.tipo ?? 'consulta',
        'observacoes': existing?.observacoes ?? '',
      },
      buildItem: (values, existing) {
        final idSala = values['id_sala']!.isEmpty ? null : int.tryParse(values['id_sala']!);
        return Consulta(
          idConsulta: existing?.idConsulta,
          idAnimal: int.parse(values['id_animal']!),
          idProfissional: int.parse(values['id_profissional']!),
          idSala: idSala,
          dataHora: values['data_hora']!,
          status: values['status']!,
          tipo: values['tipo'],
          observacoes: values['observacoes'],
          lembreteEnviado: existing?.lembreteEnviado ?? false,
        );
      },
    );
  }
}
