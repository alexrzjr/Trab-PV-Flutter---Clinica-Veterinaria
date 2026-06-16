import 'package:flutter/material.dart';

import '../../modules/animal/animal_page.dart';
import '../../modules/aplicacao_vacina/aplicacao_vacina_page.dart';
import '../../modules/cliente/cliente_page.dart';
import '../../modules/consulta/consulta_page.dart';
import '../../modules/fatura/fatura_page.dart';
import '../../modules/item_fatura/item_fatura_page.dart';
import '../../modules/medicamento/medicamento_page.dart';
import '../../modules/pagamento/pagamento_page.dart';
import '../../modules/prescricao/prescricao_page.dart';
import '../../modules/profissional/profissional_page.dart';
import '../../modules/prontuario/prontuario_page.dart';
import '../../modules/sala/sala_page.dart';
import '../../modules/vacina/vacina_page.dart';
import '../../pages/alertas_page.dart';
import '../../pages/consultas_hoje_page.dart';
import '../../pages/dashboard_page.dart';
import '../../pages/pesquisa_page.dart';
import '../../pages/relatorio_financeiro_page.dart';

enum AppSection {
  dashboard,
  consultasHoje,
  alertas,
  relatorioFinanceiro,
  pesquisa,
  clientes,
  animais,
  profissionais,
  salas,
  consultas,
  prontuarios,
  medicamentos,
  vacinas,
  prescricoes,
  aplicacoesVacina,
  faturas,
  itensFatura,
  pagamentos,
}

class MenuItem {
  final AppSection section;
  final String label;
  final IconData icon;
  final String group;
  final bool adminOnly;

  const MenuItem({
    required this.section,
    required this.label,
    required this.icon,
    required this.group,
    this.adminOnly = false,
  });
}

class AppRoutes {
  static const menuItems = [
    MenuItem(
      section: AppSection.dashboard,
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      group: 'Principal',
    ),
    MenuItem(
      section: AppSection.consultasHoje,
      label: 'Consultas de Hoje',
      icon: Icons.today_outlined,
      group: 'Principal',
    ),
    MenuItem(
      section: AppSection.alertas,
      label: 'Central de Alertas',
      icon: Icons.warning_amber_outlined,
      group: 'Principal',
    ),
    MenuItem(
      section: AppSection.relatorioFinanceiro,
      label: 'Relatório Financeiro',
      icon: Icons.assessment_outlined,
      group: 'Principal',
      adminOnly: true,
    ),
    MenuItem(
      section: AppSection.pesquisa,
      label: 'Pesquisa por ID',
      icon: Icons.search,
      group: 'Principal',
    ),
    MenuItem(
      section: AppSection.clientes,
      label: 'Clientes',
      icon: Icons.people_outline,
      group: 'Cadastros',
    ),
    MenuItem(
      section: AppSection.animais,
      label: 'Animais',
      icon: Icons.pets,
      group: 'Cadastros',
    ),
    MenuItem(
      section: AppSection.profissionais,
      label: 'Profissionais',
      icon: Icons.medical_services_outlined,
      group: 'Cadastros',
    ),
    MenuItem(
      section: AppSection.salas,
      label: 'Salas',
      icon: Icons.meeting_room_outlined,
      group: 'Cadastros',
    ),
    MenuItem(
      section: AppSection.consultas,
      label: 'Consultas',
      icon: Icons.calendar_month_outlined,
      group: 'Atendimento',
    ),
    MenuItem(
      section: AppSection.prontuarios,
      label: 'Prontuários',
      icon: Icons.folder_open_outlined,
      group: 'Atendimento',
    ),
    MenuItem(
      section: AppSection.medicamentos,
      label: 'Medicamentos',
      icon: Icons.medication_outlined,
      group: 'Farmácia',
    ),
    MenuItem(
      section: AppSection.vacinas,
      label: 'Vacinas',
      icon: Icons.vaccines_outlined,
      group: 'Farmácia',
    ),
    MenuItem(
      section: AppSection.prescricoes,
      label: 'Prescrições',
      icon: Icons.receipt_long_outlined,
      group: 'Farmácia',
    ),
    MenuItem(
      section: AppSection.aplicacoesVacina,
      label: 'Aplicação de Vacinas',
      icon: Icons.healing_outlined,
      group: 'Farmácia',
    ),
    MenuItem(
      section: AppSection.faturas,
      label: 'Faturas',
      icon: Icons.request_quote_outlined,
      group: 'Financeiro',
    ),
    MenuItem(
      section: AppSection.itensFatura,
      label: 'Itens de Fatura',
      icon: Icons.list_alt_outlined,
      group: 'Financeiro',
    ),
    MenuItem(
      section: AppSection.pagamentos,
      label: 'Pagamentos',
      icon: Icons.payments_outlined,
      group: 'Financeiro',
    ),
  ];

  static List<MenuItem> itemsForProfile(String perfil) {
    if (perfil == 'admin') return menuItems;
    return menuItems.where((m) => !m.adminOnly).toList();
  }

  static Widget pageFor(AppSection section) {
    return switch (section) {
      AppSection.dashboard => const DashboardPage(),
      AppSection.consultasHoje => const ConsultasHojePage(),
      AppSection.alertas => const AlertasPage(),
      AppSection.relatorioFinanceiro => const RelatorioFinanceiroPage(),
      AppSection.pesquisa => const PesquisaPage(),
      AppSection.clientes => const ClientePage(),
      AppSection.animais => const AnimalPage(),
      AppSection.profissionais => const ProfissionalPage(),
      AppSection.salas => const SalaPage(),
      AppSection.consultas => const ConsultaPage(),
      AppSection.prontuarios => const ProntuarioPage(),
      AppSection.medicamentos => const MedicamentoPage(),
      AppSection.vacinas => const VacinaPage(),
      AppSection.prescricoes => const PrescricaoPage(),
      AppSection.aplicacoesVacina => const AplicacaoVacinaPage(),
      AppSection.faturas => const FaturaPage(),
      AppSection.itensFatura => const ItemFaturaPage(),
      AppSection.pagamentos => const PagamentoPage(),
    };
  }

  static String titleFor(AppSection section) {
    return menuItems.firstWhere((m) => m.section == section).label;
  }
}
