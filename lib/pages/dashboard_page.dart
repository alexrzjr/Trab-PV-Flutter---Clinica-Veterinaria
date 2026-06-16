import 'package:flutter/material.dart';

import '../core/services/alertas_service.dart';
import '../core/services/search_service.dart';
import '../core/theme/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _searchService = SearchService();
  Map<String, int>? _stats;
  int _alertas = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _searchService.dashboardStats();
    final alertas = await AlertasService.instance.countAlertas();
    if (mounted) setState(() {
      _stats = stats;
      _alertas = alertas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visão Geral',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Acompanhe os principais indicadores da clínica',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          if (_alertas > 0)
            Card(
              color: Colors.orange.shade50,
              child: ListTile(
                leading: Icon(Icons.warning_amber, color: Colors.orange.shade800),
                title: Text('$_alertas alerta(s) pendente(s)'),
                subtitle: const Text('Estoque baixo ou reforço vacinal próximo'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          if (_alertas > 0) const SizedBox(height: 16),
          if (_stats == null)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _StatCard(
                  title: 'Clientes',
                  value: _stats!['clientes']!.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: 'Animais',
                  value: _stats!['animais']!.toString(),
                  icon: Icons.pets,
                  color: AppTheme.primary,
                ),
                _StatCard(
                  title: 'Consultas',
                  value: _stats!['consultas']!.toString(),
                  icon: Icons.calendar_month,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'Faturas',
                  value: _stats!['faturas']!.toString(),
                  icon: Icons.request_quote,
                  color: Colors.purple,
                ),
                _StatCard(
                  title: 'Medicamentos',
                  value: _stats!['medicamentos']!.toString(),
                  icon: Icons.medication,
                  color: Colors.teal,
                ),
                _StatCard(
                  title: 'Vacinas',
                  value: _stats!['vacinas']!.toString(),
                  icon: Icons.vaccines,
                  color: Colors.red,
                ),
              ],
            ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Módulos do Sistema',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ModuleRow(
                    icon: Icons.people_outline,
                    title: 'Gestão de Clientes e Animais',
                    description: 'Cadastro completo com histórico médico e preferências',
                  ),
                  const _ModuleRow(
                    icon: Icons.folder_open_outlined,
                    title: 'Prontuário Eletrônico',
                    description: 'Registro seguro de diagnósticos, consultas e tratamentos',
                  ),
                  const _ModuleRow(
                    icon: Icons.calendar_month_outlined,
                    title: 'Agendamento',
                    description: 'Consultas, procedimentos e controle de salas',
                  ),
                  const _ModuleRow(
                    icon: Icons.medication_outlined,
                    title: 'Medicamentos e Vacinas',
                    description: 'Estoque, prescrições, aplicações e alertas de reforço',
                  ),
                  const _ModuleRow(
                    icon: Icons.payments_outlined,
                    title: 'Faturamento',
                    description: 'Faturas, itens, pagamentos e controle financeiro',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(title, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ModuleRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryLight, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(description, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
