import 'package:sqflite/sqflite.dart';

import '../utils/password_utils.dart';

class SeedData {
  static Future<void> seedIfEmpty(Database db) async {
    await _seedUsuario(db);
    await _seedSalas(db);
    final clientes = await db.query('cliente', limit: 1);
    if (clientes.isNotEmpty) return;
    await _seedDemo(db);
  }

  static Future<void> _seedUsuario(Database db) async {
    final usuarios = await db.query('usuario', limit: 1);
    if (usuarios.isNotEmpty) return;

    await db.insert('usuario', {
      'nome': 'Administrador',
      'email': 'admin@clinica.com',
      'senha': PasswordUtils.hash('admin123'),
      'perfil': 'admin',
    });
    await db.insert('usuario', {
      'nome': 'Recepção',
      'email': 'recepcao@clinica.com',
      'senha': PasswordUtils.hash('recep123'),
      'perfil': 'recepcao',
    });
  }

  static Future<void> _seedSalas(Database db) async {
    final salas = await db.query('sala_atendimento', limit: 1);
    if (salas.isNotEmpty) return;

    await db.insert('sala_atendimento', {
      'nome': 'Sala 01 - Consultório',
      'capacidade': 1,
      'disponivel': 1,
    });
    await db.insert('sala_atendimento', {
      'nome': 'Sala 02 - Cirurgia',
      'capacidade': 1,
      'disponivel': 1,
    });
  }

  static Future<void> _seedDemo(Database db) async {
    final hoje = DateTime.now();
    final hojeStr =
        '${hoje.year}-${hoje.month.toString().padLeft(2, '0')}-${hoje.day.toString().padLeft(2, '0')}';

    final idCliente1 = await db.insert('cliente', {
      'nome': 'Maria Silva',
      'cpf': '52998224725',
      'telefone': '(11) 98765-4321',
      'email': 'maria@email.com',
      'endereco': 'Rua das Flores, 123',
      'observacoes': 'Cliente desde 2024',
      'preferencias_contato': 'WhatsApp',
    });

    final idCliente2 = await db.insert('cliente', {
      'nome': 'João Santos',
      'cpf': '39053344705',
      'telefone': '(11) 91234-5678',
      'email': 'joao@email.com',
      'endereco': 'Av. Central, 456',
      'preferencias_contato': 'Telefone',
    });

    final idAnimal1 = await db.insert('animal', {
      'id_cliente': idCliente1,
      'nome': 'Rex',
      'especie': 'Cão',
      'raca': 'Labrador',
      'sexo': 'M',
      'data_nascimento': '2020-05-15',
      'peso': 28.5,
      'historico_medico': 'Castrado em 2021. Sem alergias conhecidas.',
      'vacinacao': 'V10 em dia',
      'preferencias': 'Medo de barulho alto',
    });

    final idAnimal2 = await db.insert('animal', {
      'id_cliente': idCliente1,
      'nome': 'Mimi',
      'especie': 'Gato',
      'raca': 'Siamês',
      'sexo': 'F',
      'data_nascimento': '2022-03-10',
      'peso': 4.2,
      'vacinacao': 'Antirrábica pendente reforço',
    });

    await db.insert('animal', {
      'id_cliente': idCliente2,
      'nome': 'Thor',
      'especie': 'Cão',
      'raca': 'Pastor Alemão',
      'sexo': 'M',
      'data_nascimento': '2019-08-20',
      'peso': 35.0,
    });

    final idProf1 = await db.insert('profissional', {
      'nome': 'Dra. Ana Veterinária',
      'especialidade': 'Clínica Geral',
      'crmv': 'SP-12345',
      'telefone': '(11) 99999-1111',
      'email': 'ana@clinica.com',
    });

    final idProf2 = await db.insert('profissional', {
      'nome': 'Dr. Carlos Cirurgião',
      'especialidade': 'Cirurgia',
      'crmv': 'SP-67890',
      'email': 'carlos@clinica.com',
    });

    final idMed1 = await db.insert('medicamento', {
      'nome': 'Dipirona Vet',
      'lote': 'LOT2026A',
      'validade': '2027-06-30',
      'quantidade_estoque': 3,
      'estoque_minimo': 10,
      'tipo': 'Analgésico',
      'alerta_interacao': 'Não combinar com Meloxicam',
    });

    final idMed2 = await db.insert('medicamento', {
      'nome': 'Meloxicam',
      'lote': 'LOT2026B',
      'validade': '2027-12-31',
      'quantidade_estoque': 25,
      'estoque_minimo': 5,
      'tipo': 'Anti-inflamatório',
      'alerta_interacao': 'Não combinar com Dipirona Vet',
    });

    final idVac1 = await db.insert('vacina', {
      'nome': 'Antirrábica',
      'intervalo_reforco': 365,
    });

    final idVac2 = await db.insert('vacina', {
      'nome': 'V10',
      'intervalo_reforco': 365,
    });

    final salas = await db.query('sala_atendimento', orderBy: 'id_sala ASC');
    final idSala1 = salas.first['id_sala'] as int;

    final idConsulta1 = await db.insert('consulta', {
      'id_animal': idAnimal1,
      'id_profissional': idProf1,
      'id_sala': idSala1,
      'data_hora': '$hojeStr 09:00',
      'status': 'agendada',
      'tipo': 'consulta',
      'observacoes': 'Check-up anual',
      'lembrete_enviado': 0,
    });

    await db.insert('consulta', {
      'id_animal': idAnimal2,
      'id_profissional': idProf1,
      'id_sala': idSala1,
      'data_hora': '$hojeStr 14:30',
      'status': 'agendada',
      'tipo': 'vacina',
      'lembrete_enviado': 0,
    });

    final idProntuario1 = await db.insert('prontuario', {
      'id_animal': idAnimal1,
      'id_consulta': idConsulta1,
      'data_registro': hojeStr,
      'diagnostico': 'Saúde geral boa',
      'observacoes': 'Recomendado retorno em 6 meses',
    });

    await db.insert('prescricao', {
      'id_prontuario': idProntuario1,
      'id_medicamento': idMed2,
      'dosagem': '0.5mg/kg',
      'frequencia': '1x ao dia',
      'duracao': '5 dias',
    });

    final reforcoEm7Dias = hoje.add(const Duration(days: 7));
    final reforcoStr =
        '${reforcoEm7Dias.year}-${reforcoEm7Dias.month.toString().padLeft(2, '0')}-${reforcoEm7Dias.day.toString().padLeft(2, '0')}';

    await db.insert('aplicacao_vacina', {
      'id_prontuario': idProntuario1,
      'id_vacina': idVac1,
      'data_aplicacao': hojeStr,
      'data_reforco': reforcoStr,
    });

    final idFatura1 = await db.insert('fatura', {
      'id_cliente': idCliente1,
      'data_fatura': hojeStr,
      'valor_total': 0,
      'status': 'pendente',
      'observacoes': 'Consulta + medicamento',
    });

    await db.insert('item_fatura', {
      'id_fatura': idFatura1,
      'descricao': 'Consulta clínica geral',
      'valor': 150.0,
    });
    await db.insert('item_fatura', {
      'id_fatura': idFatura1,
      'descricao': 'Meloxicam (5 dias)',
      'valor': 45.0,
    });

    await db.update(
      'fatura',
      {'valor_total': 195.0},
      where: 'id_fatura = ?',
      whereArgs: [idFatura1],
    );

    await db.insert('aplicacao_vacina', {
      'id_prontuario': idProntuario1,
      'id_vacina': idVac2,
      'data_aplicacao': '2025-05-30',
      'data_reforco': reforcoStr,
    });
  }
}
