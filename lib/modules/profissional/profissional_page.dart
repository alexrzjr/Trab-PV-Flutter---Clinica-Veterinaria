import 'package:flutter/material.dart';

import '../../core/widgets/crud_scaffold.dart';
import 'profissional_controller.dart';
import 'profissional_model.dart';

class ProfissionalPage extends StatelessWidget {
  const ProfissionalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfissionalController();

    return CrudScaffold<Profissional>(
      title: 'Profissional',
      subtitle: 'Veterinários e equipe de atendimento',
      icon: Icons.medical_services_outlined,
      searchHint: 'Pesquisar por nome, CRMV ou ID...',
      idFieldName: 'id_profissional',
      fields: const [
        CrudField(key: 'nome', label: 'Nome', required: true),
        CrudField(key: 'especialidade', label: 'Especialidade'),
        CrudField(key: 'crmv', label: 'CRMV'),
        CrudField(key: 'telefone', label: 'Telefone', keyboardType: TextInputType.phone),
        CrudField(key: 'email', label: 'E-mail', keyboardType: TextInputType.emailAddress),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (p) => p.idProfissional,
      getTitle: (p) => p.nome,
      getSubtitle: (p) => [p.especialidade, p.crmv].where((v) => v != null && v.isNotEmpty).join(' • '),
      initialValues: (existing) => {
        'nome': existing?.nome ?? '',
        'especialidade': existing?.especialidade ?? '',
        'crmv': existing?.crmv ?? '',
        'telefone': existing?.telefone ?? '',
        'email': existing?.email ?? '',
      },
      buildItem: (values, existing) => Profissional(
        idProfissional: existing?.idProfissional,
        nome: values['nome']!,
        especialidade: values['especialidade'],
        crmv: values['crmv'],
        telefone: values['telefone'],
        email: values['email'],
      ),
    );
  }
}
