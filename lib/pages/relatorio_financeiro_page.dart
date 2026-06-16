import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/services/business_rules_service.dart';
import '../core/theme/app_theme.dart';

class RelatorioFinanceiroPage extends StatefulWidget {
  const RelatorioFinanceiroPage({super.key});

  @override
  State<RelatorioFinanceiroPage> createState() => _RelatorioFinanceiroPageState();
}

class _RelatorioFinanceiroPageState extends State<RelatorioFinanceiroPage> {
  final _service = BusinessRulesService.instance;
  final _currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  DateTime? _inicio;
  DateTime? _fim;
  Map<String, double>? _dados;
  bool _loading = false;

  Future<void> _gerar() async {
    setState(() => _loading = true);
    final dados = await _service.relatorioFinanceiro(inicio: _inicio, fim: _fim);
    setState(() {
      _dados = dados;
      _loading = false;
    });
  }

  Future<void> _pickDate(bool inicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (inicio) {
        _inicio = picked;
      } else {
        _fim = picked;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _gerar();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.assessment, color: Colors.purple.shade700),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Relatório Financeiro', style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      'Análise de faturamento, recebimentos e pendências',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(true),
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _inicio == null
                          ? 'Data início'
                          : DateFormat('dd/MM/yyyy').format(_inicio!),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(false),
                    icon: const Icon(Icons.date_range),
                    label: Text(
                      _fim == null ? 'Data fim' : DateFormat('dd/MM/yyyy').format(_fim!),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _loading ? null : _gerar,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Gerar relatório'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _inicio = null;
                        _fim = null;
                      });
                      _gerar();
                    },
                    child: const Text('Limpar filtros'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_dados != null)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _MetricCard(
                  title: 'Total Faturado',
                  value: _currency.format(_dados!['faturado']),
                  icon: Icons.request_quote,
                  color: AppTheme.primary,
                ),
                _MetricCard(
                  title: 'Total Recebido',
                  value: _currency.format(_dados!['recebido']),
                  icon: Icons.payments,
                  color: Colors.green,
                ),
                _MetricCard(
                  title: 'Contas Pendentes',
                  value: _currency.format(_dados!['pendente']),
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 12),
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }
}
