import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'cliente_controller.dart';
import 'cliente_model.dart';

class ClientePage extends StatelessWidget {
  const ClientePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ClienteController();

    return CrudScaffold<Cliente>(
      title: 'Cliente',
      subtitle: 'Cadastro de tutores e responsáveis',
      icon: Icons.people_outline,
      searchHint: 'Pesquisar por nome, CPF, e-mail ou ID...',
      idFieldName: 'id_cliente',
      fields: [
        const CrudField.text(key: 'nome', label: 'Nome', required: true),
        CrudField.text(key: 'cpf', label: 'CPF', validator: Validators.cpf),
        const CrudField.text(key: 'telefone', label: 'Telefone', keyboardType: TextInputType.phone),
        CrudField.text(key: 'email', label: 'E-mail', keyboardType: TextInputType.emailAddress, validator: Validators.email),
        const CrudField.text(key: 'endereco', label: 'Endereço'),
        const CrudField.text(key: 'preferencias_contato', label: 'Preferências de contato'),
        const CrudField.multiline(key: 'observacoes', label: 'Observações'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (c) => c.idCliente,
      getTitle: (c) => c.nome,
      getSubtitle: (c) {
        final parts = <String>[];
        if (c.telefone?.isNotEmpty == true) parts.add(c.telefone!);
        if (c.email?.isNotEmpty == true) parts.add(c.email!);
        if (c.cpf?.isNotEmpty == true) parts.add(Validators.formatCpf(c.cpf!));
        return parts.join(' • ');
      },
      initialValues: (existing) => {
        'nome': existing?.nome ?? '',
        'cpf': existing?.cpf ?? '',
        'telefone': existing?.telefone ?? '',
        'email': existing?.email ?? '',
        'endereco': existing?.endereco ?? '',
        'preferencias_contato': existing?.preferenciasContato ?? '',
        'observacoes': existing?.observacoes ?? '',
      },
      buildItem: (values, existing) => Cliente(
        idCliente: existing?.idCliente,
        nome: values['nome']!,
        cpf: values['cpf']!.replaceAll(RegExp(r'\D'), ''),
        telefone: values['telefone'],
        email: values['email'],
        endereco: values['endereco'],
        preferenciasContato: values['preferencias_contato'],
        observacoes: values['observacoes'],
      ),
    );
  }
}
