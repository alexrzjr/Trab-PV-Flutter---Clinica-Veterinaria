import 'package:flutter/material.dart';

import '../../core/services/lookup_service.dart';
import '../../core/widgets/crud_scaffold.dart';
import 'animal_controller.dart';
import 'animal_model.dart';

class AnimalPage extends StatelessWidget {
  const AnimalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AnimalController();
    final lookup = LookupService.instance;

    return CrudScaffold<Animal>(
      title: 'Animal',
      subtitle: 'Cadastro de pets e histórico básico',
      icon: Icons.pets,
      searchHint: 'Pesquisar por nome, espécie, raça ou ID...',
      idFieldName: 'id_animal',
      fields: [
        CrudField.dropdown(
          key: 'id_cliente',
          label: 'Cliente (tutor)',
          required: true,
          loadOptions: lookup.clientesOptions,
        ),
        const CrudField.text(key: 'nome', label: 'Nome', required: true),
        const CrudField.text(key: 'especie', label: 'Espécie', required: true),
        const CrudField.text(key: 'raca', label: 'Raça'),
        const CrudField.choice(key: 'sexo', label: 'Sexo', choices: ['M', 'F', 'N/I']),
        const CrudField.date(key: 'data_nascimento', label: 'Data de nascimento'),
        const CrudField.number(key: 'peso', label: 'Peso (kg)'),
        const CrudField.text(key: 'vacinacao', label: 'Vacinação'),
        const CrudField.multiline(key: 'historico_medico', label: 'Histórico médico'),
        const CrudField.multiline(key: 'preferencias', label: 'Preferências'),
      ],
      loadItems: controller.listar,
      saveItem: controller.salvar,
      deleteItem: controller.excluir,
      getId: (a) => a.idAnimal,
      getTitle: (a) => a.nome,
      getSubtitle: (a) => '${a.especie}${a.raca != null ? ' • ${a.raca}' : ''}',
      initialValues: (existing) => {
        'id_cliente': existing?.idCliente.toString() ?? '',
        'nome': existing?.nome ?? '',
        'especie': existing?.especie ?? '',
        'raca': existing?.raca ?? '',
        'sexo': existing?.sexo ?? 'M',
        'data_nascimento': existing?.dataNascimento ?? '',
        'peso': existing?.peso?.toString() ?? '',
        'vacinacao': existing?.vacinacao ?? '',
        'historico_medico': existing?.historicoMedico ?? '',
        'preferencias': existing?.preferencias ?? '',
      },
      buildItem: (values, existing) {
        final peso = values['peso']!.isEmpty ? null : double.tryParse(values['peso']!);
        return Animal(
          idAnimal: existing?.idAnimal,
          idCliente: int.parse(values['id_cliente']!),
          nome: values['nome']!,
          especie: values['especie']!,
          raca: values['raca'],
          sexo: values['sexo'],
          dataNascimento: values['data_nascimento'],
          peso: peso,
          vacinacao: values['vacinacao'],
          historicoMedico: values['historico_medico'],
          preferencias: values['preferencias'],
        );
      },
    );
  }
}
