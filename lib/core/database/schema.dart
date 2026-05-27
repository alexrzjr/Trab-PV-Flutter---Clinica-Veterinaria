class Schema {
  static const createCliente = '''
CREATE TABLE cliente (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    cpf TEXT UNIQUE,
    telefone TEXT,
    email TEXT,
    endereco TEXT,
    observacoes TEXT
);
''';

  static const createAnimal = '''
CREATE TABLE animal (
    id_animal INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    nome TEXT NOT NULL,
    especie TEXT NOT NULL,
    raca TEXT,
    sexo TEXT,
    data_nascimento TEXT,
    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
        ON DELETE CASCADE
);
''';

  static const createProfissional = '''
CREATE TABLE profissional (
  id_profissional INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  especialidade TEXT,
  crmv TEXT UNIQUE
);
''';
  static const createConsulta = '''
CREATE TABLE consulta (
  id_consulta INTEGER PRIMARY KEY AUTOINCREMENT,
  id_animal INTEGER NOT NULL,
  id_profissional INTEGER NOT NULL,
  data_hora TEXT NOT NULL,
  status TEXT NOT NULL,
  tipo TEXT,
  FOREIGN KEY (id_animal)
    REFERENCES animal(id_animal),
  FOREIGN KEY (id_profissional)
    REFERENCES profissional(id_profissional)
);
''';

  static const createProntuario = '''
CREATE TABLE prontuario (
  id_prontuario INTEGER PRIMARY KEY AUTOINCREMENT,
  id_animal INTEGER NOT NULL,
  id_consulta INTEGER UNIQUE,
  data_registro TEXT NOT NULL,
  diagnostico TEXT,
  observacoes TEXT,
  FOREIGN KEY (id_animal)
    REFERENCES animal(id_animal),
  FOREIGN KEY (id_consulta)
    REFERENCES consulta(id_consulta)
);
''';

  static const createMedicamento = '''
CREATE TABLE medicamento (
  id_medicamento INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  lote TEXT,
  validade TEXT,
  quantidade_estoque INTEGER NOT NULL,
  tipo TEXT
);
''';

  static const createVacina = '''
CREATE TABLE vacina (
  id_vacina INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  intervalo_reforco INTEGER NOT NULL
);
''';

  static const createPrescricao = '''
CREATE TABLE prescricao (
  id_prescricao INTEGER PRIMARY KEY AUTOINCREMENT,
  id_prontuario INTEGER NOT NULL,
  id_medicamento INTEGER NOT NULL,
  dosagem TEXT,
  frequencia TEXT,
  duracao TEXT,
  FOREIGN KEY (id_prontuario)
    REFERENCES prontuario(id_prontuario)
    ON DELETE CASCADE,
  FOREIGN KEY (id_medicamento)
    REFERENCES medicamento(id_medicamento)
);
''';

  static const createAplicacaoVacina = '''
CREATE TABLE aplicacao_vacina (
  id_aplicacao INTEGER PRIMARY KEY AUTOINCREMENT,
  id_prontuario INTEGER NOT NULL,
  id_vacina INTEGER NOT NULL,
  data_aplicacao TEXT NOT NULL,
  data_reforco TEXT,
  FOREIGN KEY (id_prontuario)
    REFERENCES prontuario(id_prontuario)
    ON DELETE CASCADE,
  FOREIGN KEY (id_vacina)
    REFERENCES vacina(id_vacina)
);
''';

  static const createFatura = '''
CREATE TABLE fatura (
  id_fatura INTEGER PRIMARY KEY AUTOINCREMENT,
  id_cliente INTEGER NOT NULL,
  data_fatura TEXT NOT NULL,
  valor_total REAL NOT NULL,
  status TEXT NOT NULL,
  FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
);
''';

  static const createItemFatura = '''
CREATE TABLE item_fatura (
  id_item INTEGER PRIMARY KEY AUTOINCREMENT,
  id_fatura INTEGER NOT NULL,
  descricao TEXT NOT NULL,
  valor REAL NOT NULL,
  FOREIGN KEY (id_fatura)
    REFERENCES fatura(id_fatura)
    ON DELETE CASCADE
);
''';
}
