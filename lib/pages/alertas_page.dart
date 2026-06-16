import 'package:flutter/material.dart';

import '../core/services/alertas_service.dart';
import '../core/theme/app_theme.dart';

class AlertasPage extends StatefulWidget {
  const AlertasPage({super.key});

  @override
  State<AlertasPage> createState() => _AlertasPageState();
}

class _AlertasPageState extends State<AlertasPage> {
  final _service = AlertasService.instance;
  List<Map<String, dynamic>> _estoque = [];
  List<Map<String, dynamic>> _vacinas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    final estoque = await _service.medicamentosEstoqueBaixo();
    final vacinas = await _service.vacinasReforcoProximo();
    setState(() {
      _estoque = estoque;
      _vacinas = vacinas;
      _loading = false;
    });
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
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Central de Alertas', style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      'Estoque baixo, reforços vacinais e alertas do sistema',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: _carregar, icon: const Icon(Icons.refresh)),
            ],
          ),
          const SizedBox(height: 24),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else ...[
            _SectionTitle(
              icon: Icons.medication,
              title: 'Medicamentos — Estoque Baixo',
              count: _estoque.length,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            if (_estoque.isEmpty)
              _EmptyCard(message: 'Nenhum medicamento com estoque crítico')
            else
              ..._estoque.map(
                (m) => Card(
                  child: ListTile(
                    leading: Icon(Icons.error_outline, color: Colors.red.shade400),
                    title: Text(m['nome'] as String),
                    subtitle: Text(
                      'Estoque: ${m['quantidade_estoque']} (mín: ${m['estoque_minimo']}) • ${m['tipo'] ?? ''}',
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _SectionTitle(
              icon: Icons.vaccines,
              title: 'Vacinas — Reforço nos próximos 30 dias',
              count: _vacinas.length,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 8),
            if (_vacinas.isEmpty)
              _EmptyCard(message: 'Nenhum reforço vacinal próximo')
            else
              ..._vacinas.map(
                (v) => Card(
                  child: ListTile(
                    leading: Icon(Icons.calendar_month, color: AppTheme.primaryLight),
                    title: Text(v['nome_vacina'] as String? ?? 'Vacina'),
                    subtitle: Text(
                      'Reforço: ${v['data_reforco']} • Prontuário #${v['id_prontuario']}',
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 12,
          backgroundColor: color.withValues(alpha: 0.15),
          child: Text('$count', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(message, style: TextStyle(color: Colors.grey.shade600))),
      ),
    );
  }
}
