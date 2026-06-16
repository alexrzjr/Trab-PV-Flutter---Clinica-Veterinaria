import '../../core/database/database_helper.dart';
import '../../modules/consulta/consulta_model.dart';
import '../../modules/consulta/consulta_repository.dart';
import '../../modules/fatura/fatura_repository.dart';
import '../../modules/item_fatura/item_fatura_repository.dart';
import '../../modules/medicamento/medicamento_model.dart';
import '../../modules/medicamento/medicamento_repository.dart';
import '../../modules/pagamento/pagamento_repository.dart';
import '../../modules/prescricao/prescricao_model.dart';
import '../../modules/prescricao/prescricao_repository.dart';

class BusinessRulesService {
  BusinessRulesService._();
  static final BusinessRulesService instance = BusinessRulesService._();

  final _db = DatabaseHelper.instance;
  final _consultaRepo = ConsultaRepository();
  final _faturaRepo = FaturaRepository();
  final _itemFaturaRepo = ItemFaturaRepository();
  final _pagamentoRepo = PagamentoRepository();
  final _prescricaoRepo = PrescricaoRepository();
  final _medicamentoRepo = MedicamentoRepository();

  Future<void> validarConsulta(Consulta consulta) async {
    final conflitos = await _consultaRepo.findConflicts(consulta);
    if (conflitos.isNotEmpty) {
      throw Exception(
        'Conflito de horário: profissional ou sala já possui consulta em ${consulta.dataHora}',
      );
    }
  }

  Future<void> validarPrescricao(Prescricao prescricao) async {
    final medicamento = await _medicamentoRepo.findById(prescricao.idMedicamento);
    if (medicamento == null) throw Exception('Medicamento não encontrado');

    if (medicamento.quantidadeEstoque <= 0) {
      throw Exception('Estoque insuficiente para ${medicamento.nome}');
    }

    final existentes = await _prescricaoRepo.findByProntuarioId(prescricao.idProntuario);
    for (final p in existentes) {
      if (p.idPrescricao == prescricao.idPrescricao) continue;
      final outro = await _medicamentoRepo.findById(p.idMedicamento);
      if (outro != null && _temInteracao(medicamento, outro)) {
        throw Exception(
          'Interação medicamentosa detectada entre "${medicamento.nome}" e "${outro.nome}"',
        );
      }
    }
  }

  bool _temInteracao(Medicamento a, Medicamento b) {
    final alertaA = (a.alertaInteracao ?? '').toLowerCase();
    final alertaB = (b.alertaInteracao ?? '').toLowerCase();
    final nomeA = a.nome.toLowerCase();
    final nomeB = b.nome.toLowerCase();
    return alertaA.contains(nomeB) || alertaB.contains(nomeA);
  }

  Future<void> baixarEstoquePrescricao(Prescricao prescricao) async {
    final med = await _medicamentoRepo.findById(prescricao.idMedicamento);
    if (med == null) return;
    final novo = Medicamento(
      idMedicamento: med.idMedicamento,
      nome: med.nome,
      lote: med.lote,
      validade: med.validade,
      quantidadeEstoque: med.quantidadeEstoque - 1,
      estoqueMinimo: med.estoqueMinimo,
      tipo: med.tipo,
      alertaInteracao: med.alertaInteracao,
    );
    await _medicamentoRepo.update(novo);
  }

  Future<void> recalcularFatura(int idFatura) async {
    final itens = await _itemFaturaRepo.findByFaturaId(idFatura);
    final total = itens.fold<double>(0, (s, i) => s + i.valor);
    final fatura = await _faturaRepo.findById(idFatura);
    if (fatura == null) return;

    await _faturaRepo.updateValorTotal(
      idFatura,
      total,
      status: fatura.status == 'pago' ? 'pago' : fatura.status,
    );
  }

  Future<void> atualizarStatusFaturaPorPagamentos(int idFatura) async {
    final fatura = await _faturaRepo.findById(idFatura);
    if (fatura == null) return;

    final pagamentos = await _pagamentoRepo.findByFaturaId(idFatura);
    final pago = pagamentos.fold<double>(0, (s, p) => s + p.valor);

    String status = fatura.status;
    if (pago >= fatura.valorTotal && fatura.valorTotal > 0) {
      status = 'pago';
    } else if (pago > 0) {
      status = 'parcial';
    } else if (status != 'cancelado') {
      status = 'pendente';
    }

    await _faturaRepo.updateValorTotal(idFatura, fatura.valorTotal, status: status);
  }

  Future<Map<String, double>> relatorioFinanceiro({DateTime? inicio, DateTime? fim}) async {
    final db = await _db.database;
    final faturas = await db.query('fatura');
    final pagamentos = await db.query('pagamento');

    double totalFaturado = 0;
    double totalRecebido = 0;
    double totalPendente = 0;

    for (final f in faturas) {
      final data = f['data_fatura'] as String?;
      if (!_inPeriodo(data, inicio, fim)) continue;
      final valor = (f['valor_total'] as num?)?.toDouble() ?? 0;
      final status = f['status'] as String? ?? 'pendente';
      totalFaturado += valor;
      if (status == 'pago') {
        totalRecebido += valor;
      } else if (status != 'cancelado') {
        totalPendente += valor;
      }
    }

    double pagamentosPeriodo = 0;
    for (final p in pagamentos) {
      final data = p['data_pagamento'] as String?;
      if (!_inPeriodo(data, inicio, fim)) continue;
      pagamentosPeriodo += (p['valor'] as num?)?.toDouble() ?? 0;
    }

    return {
      'faturado': totalFaturado,
      'recebido': pagamentosPeriodo,
      'pendente': totalPendente,
    };
  }

  bool _inPeriodo(String? dataIso, DateTime? inicio, DateTime? fim) {
    if (inicio == null && fim == null) return true;
    if (dataIso == null || dataIso.length < 10) return false;
    final parts = dataIso.substring(0, 10).split('-').map(int.parse).toList();
    final dt = DateTime(parts[0], parts[1], parts[2]);
    if (inicio != null && dt.isBefore(DateTime(inicio.year, inicio.month, inicio.day))) {
      return false;
    }
    if (fim != null && dt.isAfter(DateTime(fim.year, fim.month, fim.day, 23, 59, 59))) {
      return false;
    }
    return true;
  }
}
