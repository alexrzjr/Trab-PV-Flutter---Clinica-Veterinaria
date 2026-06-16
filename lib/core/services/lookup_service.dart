import '../../modules/animal/animal_repository.dart';
import '../../modules/cliente/cliente_repository.dart';
import '../../modules/consulta/consulta_repository.dart';
import '../../modules/fatura/fatura_repository.dart';
import '../../modules/medicamento/medicamento_repository.dart';
import '../../modules/profissional/profissional_repository.dart';
import '../../modules/prontuario/prontuario_repository.dart';
import '../../modules/sala/sala_repository.dart';
import '../../modules/vacina/vacina_repository.dart';

class LookupService {
  LookupService._();
  static final LookupService instance = LookupService._();

  final _clienteRepo = ClienteRepository();
  final _animalRepo = AnimalRepository();
  final _profissionalRepo = ProfissionalRepository();
  final _salaRepo = SalaRepository();
  final _prontuarioRepo = ProntuarioRepository();
  final _medicamentoRepo = MedicamentoRepository();
  final _vacinaRepo = VacinaRepository();
  final _faturaRepo = FaturaRepository();

  Map<int, String> _clientes = {};
  Map<int, String> _animais = {};
  Map<int, String> _profissionais = {};
  Map<int, String> _salas = {};
  Map<int, String> _prontuarios = {};
  Map<int, String> _medicamentos = {};
  Map<int, String> _vacinas = {};
  Map<int, String> _faturas = {};

  void invalidateAll() {
    _clientes = {};
    _animais = {};
    _profissionais = {};
    _salas = {};
    _prontuarios = {};
    _medicamentos = {};
    _vacinas = {};
    _faturas = {};
  }

  Future<Map<String, String>> clientesOptions() async {
    if (_clientes.isEmpty) {
      final list = await _clienteRepo.findAll();
      _clientes = {for (final c in list) c.idCliente!: c.nome};
    }
    return _clientes.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> animaisOptions() async {
    if (_animais.isEmpty) {
      final list = await _animalRepo.findAll();
      _animais = {for (final a in list) a.idAnimal!: '${a.nome} (${a.especie})'};
    }
    return _animais.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> profissionaisOptions() async {
    if (_profissionais.isEmpty) {
      final list = await _profissionalRepo.findAll();
      _profissionais = {for (final p in list) p.idProfissional!: p.nome};
    }
    return _profissionais.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> salasOptions() async {
    if (_salas.isEmpty) {
      final list = await _salaRepo.findAll();
      _salas = {for (final s in list) s.idSala!: s.nome};
    }
    return _salas.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> prontuariosOptions() async {
    if (_prontuarios.isEmpty) {
      final list = await _prontuarioRepo.findAll();
      _prontuarios = {
        for (final p in list)
          p.idProntuario!: 'Pront. #${p.idProntuario} — Animal #${p.idAnimal}',
      };
    }
    return _prontuarios.map((k, v) => MapEntry(k.toString(), v));
  }

  Future<Map<String, String>> medicamentosOptions() async {
    if (_medicamentos.isEmpty) {
      final list = await _medicamentoRepo.findAll();
      _medicamentos = {for (final m in list) m.idMedicamento!: m.nome};
    }
    return _medicamentos.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> vacinasOptions() async {
    if (_vacinas.isEmpty) {
      final list = await _vacinaRepo.findAll();
      _vacinas = {for (final v in list) v.idVacina!: v.nome};
    }
    return _vacinas.map((k, v) => MapEntry(k.toString(), '#$k — $v'));
  }

  Future<Map<String, String>> faturasOptions() async {
    if (_faturas.isEmpty) {
      final list = await _faturaRepo.findAll();
      _faturas = {
        for (final f in list)
          f.idFatura!: 'Fatura #${f.idFatura} — Cliente #${f.idCliente} (R\$ ${f.valorTotal.toStringAsFixed(2)})',
      };
    }
    return _faturas.map((k, v) => MapEntry(k.toString(), v));
  }

  Future<String> clienteNome(int id) async {
    await clientesOptions();
    return _clientes[id] ?? 'Cliente #$id';
  }

  Future<String> animalNome(int id) async {
    await animaisOptions();
    return _animais[id] ?? 'Animal #$id';
  }

  Future<String> profissionalNome(int id) async {
    await profissionaisOptions();
    return _profissionais[id] ?? 'Profissional #$id';
  }

  Future<String> salaNome(int id) async {
    await salasOptions();
    return _salas[id] ?? 'Sala #$id';
  }

  Future<String> medicamentoNome(int id) async {
    await medicamentosOptions();
    return _medicamentos[id] ?? 'Medicamento #$id';
  }
}
