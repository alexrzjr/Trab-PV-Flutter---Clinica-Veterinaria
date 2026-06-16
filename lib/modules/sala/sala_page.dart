import 'package:flutter/material.dart';

import '../../core/widgets/crud_scaffold.dart';
import 'sala_controller.dart';
import 'sala_model.dart';

class SalaPage extends StatelessWidget {
  const SalaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SalaController();

    return CrudScaffold<Sala>(
      title: 'Sala',
      subtitle: 'Salas de atendimento e procedimentos',
      icon: Icons.meeting_room_outlined,
      searchHint: 'Pesquisar por nome ou ID...',
      idFieldName: 'id_sala',
      fields: const [
        CrudField.text(key: 'nome', label: 'Nome', required: true),
        CrudField.number(key: 'capacidade', label: 'Capacidade'),
        CrudField.choice(key: 'disponivel', label: 'Disponível', choices: ['sim', 'nao']),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (s) => s.idSala,
      getTitle: (s) => s.nome,
      getSubtitle: (s) => 'Capacidade: ${s.capacidade} • ${s.disponivel ? 'Disponível' : 'Indisponível'}',
      initialValues: (existing) => {
        'nome': existing?.nome ?? '',
        'capacidade': existing?.capacidade.toString() ?? '1',
        'disponivel': existing?.disponivel == false ? 'nao' : 'sim',
      },
      buildItem: (values, existing) => Sala(
        idSala: existing?.idSala,
        nome: values['nome']!,
        capacidade: int.tryParse(values['capacidade'] ?? '') ?? 1,
        disponivel: values['disponivel'] != 'nao',
      ),
    );
  }
}
