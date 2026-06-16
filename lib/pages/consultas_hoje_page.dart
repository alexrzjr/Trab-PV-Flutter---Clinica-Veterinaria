import 'package:flutter/material.dart';

import '../core/services/lookup_service.dart';
import '../core/theme/app_theme.dart';
import '../modules/consulta/consulta_controller.dart';
import '../modules/consulta/consulta_model.dart';

class ConsultasHojePage extends StatefulWidget {
  const ConsultasHojePage({super.key});

  @override
  State<ConsultasHojePage> createState() => _ConsultasHojePageState();
}

class _ConsultasHojePageState extends State<ConsultasHojePage> {
  final _controller = ConsultaController();
  final _lookup = LookupService.instance;
  List<Consulta>? _consultas;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() => _loading = true);
    final lista = await _controller.listarHoje();
    setState(() {
      _consultas = lista;
      _loading = false;
    });
  }

  Future<void> _enviarLembrete(Consulta c) async {
    if (c.idConsulta == null) return;
    await _controller.enviarLembrete(c.idConsulta!);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Lembrete enviado para tutor do animal #${c.idAnimal} (simulação SMS/e-mail)',
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );
    _carregar();
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.today, color: AppTheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consultas de Hoje', style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                      'Agenda do dia com envio de lembretes automáticos',
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
          else if (_consultas!.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Nenhuma consulta agendada para hoje',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              ),
            )
          else
            ..._consultas!.map((c) => _ConsultaCard(
                  consulta: c,
                  lookup: _lookup,
                  onLembrete: () => _enviarLembrete(c),
                )),
        ],
      ),
    );
  }
}

class _ConsultaCard extends StatelessWidget {
  final Consulta consulta;
  final LookupService lookup;
  final VoidCallback onLembrete;

  const _ConsultaCard({
    required this.consulta,
    required this.lookup,
    required this.onLembrete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  consulta.dataHora,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Chip(
                  label: Text(consulta.status),
                  backgroundColor: Colors.blue.shade50,
                ),
              ],
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: Future.wait([
                lookup.animalNome(consulta.idAnimal),
                lookup.profissionalNome(consulta.idProfissional),
                if (consulta.idSala != null) lookup.salaNome(consulta.idSala!) else Future.value(''),
              ]),
              builder: (context, snap) {
                if (!snap.hasData) return const LinearProgressIndicator();
                final data = snap.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Animal: ${data[0]}'),
                    Text('Profissional: ${data[1]}'),
                    if (consulta.idSala != null) Text('Sala: ${data[2]}'),
                  ],
                );
              },
            ),
            if (consulta.observacoes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(consulta.observacoes!, style: TextStyle(color: Colors.grey.shade700)),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (consulta.lembreteEnviado)
                  Chip(
                    avatar: Icon(Icons.check, size: 16, color: Colors.green.shade700),
                    label: const Text('Lembrete enviado'),
                    backgroundColor: Colors.green.shade50,
                  )
                else
                  FilledButton.icon(
                    onPressed: onLembrete,
                    icon: const Icon(Icons.notifications_active_outlined, size: 18),
                    label: const Text('Enviar lembrete'),
                  ),
                const SizedBox(width: 8),
                Text(
                  consulta.tipo ?? 'consulta',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
