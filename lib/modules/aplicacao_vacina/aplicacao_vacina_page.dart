import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'aplicacao_vacina_controller.dart';
import 'aplicacao_vacina_model.dart';

class AplicacaoVacinaPage extends StatelessWidget {
  const AplicacaoVacinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AplicacaoVacinaController();
    final lookup = LookupService.instance;

    return CrudScaffold<AplicacaoVacina>(
      title: 'Aplicação de Vacina',
      subtitle: 'Registro de vacinas aplicadas e reforços',
      icon: Icons.healing_outlined,
      searchHint: 'Pesquisar por data ou ID...',
      idFieldName: 'id_aplicacao',
      fields: [
        CrudField.dropdown(key: 'id_prontuario', label: 'Prontuário', required: true, loadOptions: lookup.prontuariosOptions),
        CrudField.dropdown(key: 'id_vacina', label: 'Vacina', required: true, loadOptions: lookup.vacinasOptions),
        const CrudField.date(key: 'data_aplicacao', label: 'Data de aplicação', required: true),
        const CrudField.date(key: 'data_reforco', label: 'Data de reforço'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (a) => a.idAplicacao,
      getTitle: (a) => 'Aplicação #${a.idAplicacao}',
      getSubtitle: (a) => 'Prontuário #${a.idProntuario} • ${a.dataAplicacao}',
      initialValues: (existing) => {
        'id_prontuario': existing?.idProntuario.toString() ?? '',
        'id_vacina': existing?.idVacina.toString() ?? '',
        'data_aplicacao': existing?.dataAplicacao ?? '',
        'data_reforco': existing?.dataReforco ?? '',
      },
      buildItem: (values, existing) => AplicacaoVacina(
        idAplicacao: existing?.idAplicacao,
        idProntuario: int.parse(values['id_prontuario']!),
        idVacina: int.parse(values['id_vacina']!),
        dataAplicacao: values['data_aplicacao']!,
        dataReforco: values['data_reforco'],
      ),
    );
  }
}
