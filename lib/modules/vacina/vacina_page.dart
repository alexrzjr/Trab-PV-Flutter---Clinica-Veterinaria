import 'package:flutter/material.dart';

import '../../core/widgets/crud_scaffold.dart';
import 'vacina_controller.dart';
import 'vacina_model.dart';

class VacinaPage extends StatelessWidget {
  const VacinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VacinaController();

    return CrudScaffold<Vacina>(
      title: 'Vacina',
      subtitle: 'Cadastro de vacinas e intervalo de reforço',
      icon: Icons.vaccines_outlined,
      searchHint: 'Pesquisar por nome ou ID...',
      idFieldName: 'id_vacina',
      fields: const [
        CrudField(key: 'nome', label: 'Nome', required: true),
        CrudField(key: 'intervalo_reforco', label: 'Intervalo de reforço (dias)', keyboardType: TextInputType.number),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (v) => v.idVacina,
      getTitle: (v) => v.nome,
      getSubtitle: (v) => 'Reforço a cada ${v.intervaloReforco} dias',
      initialValues: (existing) => {
        'nome': existing?.nome ?? '',
        'intervalo_reforco': existing?.intervaloReforco.toString() ?? '365',
      },
      buildItem: (values, existing) => Vacina(
        idVacina: existing?.idVacina,
        nome: values['nome']!,
        intervaloReforco: int.tryParse(values['intervalo_reforco'] ?? '') ?? 365,
      ),
    );
  }
}
