import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'prontuario_controller.dart';
import 'prontuario_model.dart';

class ProntuarioPage extends StatelessWidget {
  const ProntuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProntuarioController();
    final lookup = LookupService.instance;

    return CrudScaffold<Prontuario>(
      title: 'Prontuário',
      subtitle: 'Histórico médico eletrônico dos animais',
      icon: Icons.folder_open_outlined,
      searchHint: 'Pesquisar por diagnóstico, data ou ID...',
      idFieldName: 'id_prontuario',
      fields: [
        CrudField.dropdown(key: 'id_animal', label: 'Animal', required: true, loadOptions: lookup.animaisOptions),
        CrudField.text(
          key: 'id_consulta',
          label: 'ID da Consulta (opcional)',
          keyboardType: TextInputType.number,
        ),
        const CrudField.date(key: 'data_registro', label: 'Data do registro', required: true),
        const CrudField.multiline(key: 'diagnostico', label: 'Diagnóstico'),
        const CrudField.multiline(key: 'observacoes', label: 'Observações'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (p) => p.idProntuario,
      getTitle: (p) => p.diagnostico?.isNotEmpty == true ? p.diagnostico! : 'Prontuário #${p.idProntuario}',
      getSubtitle: (p) => 'Animal #${p.idAnimal} • ${p.dataRegistro}',
      initialValues: (existing) => {
        'id_animal': existing?.idAnimal.toString() ?? '',
        'id_consulta': existing?.idConsulta?.toString() ?? '',
        'data_registro': existing?.dataRegistro ?? '',
        'diagnostico': existing?.diagnostico ?? '',
        'observacoes': existing?.observacoes ?? '',
      },
      buildItem: (values, existing) {
        final idConsulta = values['id_consulta']!.isEmpty ? null : int.tryParse(values['id_consulta']!);
        return Prontuario(
          idProntuario: existing?.idProntuario,
          idAnimal: int.parse(values['id_animal']!),
          idConsulta: idConsulta,
          dataRegistro: values['data_registro']!,
          diagnostico: values['diagnostico'],
          observacoes: values['observacoes'],
        );
      },
    );
  }
}
