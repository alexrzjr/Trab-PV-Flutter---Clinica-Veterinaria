import '../../core/database/database_helper.dart';
import '../../modules/animal/animal_repository.dart';
import '../../modules/aplicacao_vacina/aplicacao_vacina_repository.dart';
import '../../modules/cliente/cliente_repository.dart';
import '../../modules/consulta/consulta_repository.dart';
import '../../modules/fatura/fatura_repository.dart';
import '../../modules/item_fatura/item_fatura_repository.dart';
import '../../modules/medicamento/medicamento_repository.dart';
import '../../modules/pagamento/pagamento_repository.dart';
import '../../modules/prescricao/prescricao_repository.dart';
import '../../modules/profissional/profissional_repository.dart';
import '../../modules/prontuario/prontuario_repository.dart';
import '../../modules/sala/sala_repository.dart';
import '../../modules/usuario/usuario_repository.dart';
import '../../modules/vacina/vacina_repository.dart';

class SearchResult {
  final String entity;
  final int id;
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> related;

  SearchResult({
    required this.entity,
    required this.id,
    required this.data,
    this.related = const [],
  });
}

class SearchService {
  final _db = DatabaseHelper.instance;
  final _clienteRepo = ClienteRepository();
  final _animalRepo = AnimalRepository();
  final _profissionalRepo = ProfissionalRepository();
  final _salaRepo = SalaRepository();
  final _consultaRepo = ConsultaRepository();
  final _prontuarioRepo = ProntuarioRepository();
  final _medicamentoRepo = MedicamentoRepository();
  final _vacinaRepo = VacinaRepository();
  final _prescricaoRepo = PrescricaoRepository();
  final _aplicacaoRepo = AplicacaoVacinaRepository();
  final _faturaRepo = FaturaRepository();
  final _itemFaturaRepo = ItemFaturaRepository();
  final _pagamentoRepo = PagamentoRepository();
  final _usuarioRepo = UsuarioRepository();

  static const entities = {
    'cliente': 'Cliente',
    'animal': 'Animal',
    'profissional': 'Profissional',
    'sala_atendimento': 'Sala de Atendimento',
    'consulta': 'Consulta',
    'prontuario': 'Prontuário',
    'medicamento': 'Medicamento',
    'vacina': 'Vacina',
    'prescricao': 'Prescrição',
    'aplicacao_vacina': 'Aplicação de Vacina',
    'fatura': 'Fatura',
    'item_fatura': 'Item de Fatura',
    'pagamento': 'Pagamento',
    'usuario': 'Usuário',
  };

  Future<SearchResult?> searchById(String entity, int id) async {
    switch (entity) {
      case 'cliente':
        final item = await _clienteRepo.findById(id);
        if (item == null) return null;
        final animais = await _animalRepo.findByClienteId(id);
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_cliente'] = id),
          related: animais.map((a) => a.toMap()).toList(),
        );
      case 'animal':
        final item = await _animalRepo.findById(id);
        if (item == null) return null;
        final prontuarios = await _prontuarioRepo.findByAnimalId(id);
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_animal'] = id),
          related: prontuarios.map((p) => p.toMap()).toList(),
        );
      case 'profissional':
        final item = await _profissionalRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_profissional'] = id),
        );
      case 'sala_atendimento':
        final item = await _salaRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_sala'] = id),
        );
      case 'consulta':
        final item = await _consultaRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_consulta'] = id),
        );
      case 'prontuario':
        final item = await _prontuarioRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_prontuario'] = id),
        );
      case 'medicamento':
        final item = await _medicamentoRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_medicamento'] = id),
        );
      case 'vacina':
        final item = await _vacinaRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_vacina'] = id),
        );
      case 'prescricao':
        final item = await _prescricaoRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_prescricao'] = id),
        );
      case 'aplicacao_vacina':
        final item = await _aplicacaoRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_aplicacao'] = id),
        );
      case 'fatura':
        final item = await _faturaRepo.findById(id);
        if (item == null) return null;
        final itens = await _itemFaturaRepo.findByFaturaId(id);
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_fatura'] = id),
          related: itens.map((i) => i.toMap()).toList(),
        );
      case 'item_fatura':
        final item = await _itemFaturaRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_item'] = id),
        );
      case 'pagamento':
        final item = await _pagamentoRepo.findById(id);
        if (item == null) return null;
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(item.toMap()..['id_pagamento'] = id),
        );
      case 'usuario':
        final item = await _usuarioRepo.findById(id);
        if (item == null) return null;
        final map = item.toMap();
        map.remove('senha');
        return SearchResult(
          entity: entities[entity]!,
          id: id,
          data: _sanitize(map..['id_usuario'] = id),
        );
      default:
        return null;
    }
  }

  Future<Map<String, int>> dashboardStats() async {
    final db = await _db.database;
    Future<int> count(String table) async {
      final r = await db.rawQuery('SELECT COUNT(*) as c FROM $table');
      return (r.first['c'] as int?) ?? 0;
    }

    return {
      'clientes': await count('cliente'),
      'animais': await count('animal'),
      'consultas': await count('consulta'),
      'faturas': await count('fatura'),
      'medicamentos': await count('medicamento'),
      'vacinas': await count('vacina'),
    };
  }

  Map<String, dynamic> _sanitize(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    copy.remove('senha');
    return copy;
  }
}
