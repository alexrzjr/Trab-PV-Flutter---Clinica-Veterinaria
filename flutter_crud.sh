#!/bin/bash

TABLE_NAME=$1
SCHEMA_FILE="crud_schema.conf"

if [ -z "$TABLE_NAME" ]; then
  echo "❌ Você esqueceu o nome da tabela, gênio."
  echo "Uso: ./flutter_crud.sh cliente"
  exit 1
fi

if [ ! -f "$SCHEMA_FILE" ]; then
  echo "❌ Arquivo crud_schema.conf não encontrado. Aprende a organizar projeto."
  exit 1
fi

LINE=$(grep "^$TABLE_NAME:" "$SCHEMA_FILE")

if [ -z "$LINE" ]; then
  echo "❌ Tabela '$TABLE_NAME' não existe no crud_schema.conf"
  exit 1
fi

FIELDS=$(echo "$LINE" | cut -d':' -f2)
IFS=',' read -ra COLS <<< "$FIELDS"

ID_FIELD=${COLS[0]}
ENTITY_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${TABLE_NAME:0:1})${TABLE_NAME:1}"
MODULE_DIR="lib/modules/$TABLE_NAME"

mkdir -p "$MODULE_DIR"

# ================= MODEL =================
cat > "$MODULE_DIR/${TABLE_NAME}_model.dart" <<EOF
class $ENTITY_NAME {
EOF

for col in "${COLS[@]}"; do
  echo "  final dynamic $col;" >> "$MODULE_DIR/${TABLE_NAME}_model.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_model.dart" <<EOF

  $ENTITY_NAME({
EOF

for col in "${COLS[@]}"; do
  echo "    this.$col," >> "$MODULE_DIR/${TABLE_NAME}_model.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_model.dart" <<EOF
  });

  factory $ENTITY_NAME.fromMap(Map<String, dynamic> map) {
    return $ENTITY_NAME(
EOF

for col in "${COLS[@]}"; do
  echo "      $col: map['$col']," >> "$MODULE_DIR/${TABLE_NAME}_model.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_model.dart" <<EOF
    );
  }

  Map<String, dynamic> toMap() {
    return {
EOF

for col in "${COLS[@]:1}"; do
  echo "      '$col': $col," >> "$MODULE_DIR/${TABLE_NAME}_model.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_model.dart" <<EOF
    };
  }
}
EOF

# ================= REPOSITORY =================
cat > "$MODULE_DIR/${TABLE_NAME}_repository.dart" <<EOF
import 'package:sqflite/sqflite.dart';
import '../../core/database/database_helper.dart';
import '${TABLE_NAME}_model.dart';

class ${ENTITY_NAME}Repository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert($ENTITY_NAME obj) async {
    final db = await dbHelper.database;
    return await db.insert('$TABLE_NAME', obj.toMap());
  }

  Future<List<$ENTITY_NAME>> findAll({String? search}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      '$TABLE_NAME',
      where: search != null ? '${COLS[1]} LIKE ?' : null,
      whereArgs: search != null ? ['%$search%'] : null,
    );
    return result.map((e) => $ENTITY_NAME.fromMap(e)).toList();
  }

  Future<int> update($ENTITY_NAME obj) async {
    final db = await dbHelper.database;
    return await db.update(
      '$TABLE_NAME',
      obj.toMap(),
      where: '$ID_FIELD = ?',
      whereArgs: [obj.$ID_FIELD],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      '$TABLE_NAME',
      where: '$ID_FIELD = ?',
      whereArgs: [id],
    );
  }
}
EOF

# ================= CONTROLLER =================
cat > "$MODULE_DIR/${TABLE_NAME}_controller.dart" <<EOF
import '${TABLE_NAME}_repository.dart';
import '${TABLE_NAME}_model.dart';

class ${ENTITY_NAME}Controller {
  final repository = ${ENTITY_NAME}Repository();

  Future<List<$ENTITY_NAME>> listar({String? busca}) {
    return repository.findAll(search: busca);
  }

  Future salvar($ENTITY_NAME obj) {
    if (obj.$ID_FIELD == null) {
      return repository.insert(obj);
    } else {
      return repository.update(obj);
    }
  }

  Future excluir(int id) {
    return repository.delete(id);
  }
}
EOF

# ================= PAGE =================
cat > "$MODULE_DIR/${TABLE_NAME}_page.dart" <<EOF
import 'package:flutter/material.dart';
import '${TABLE_NAME}_controller.dart';
import '${TABLE_NAME}_model.dart';

class ${ENTITY_NAME}Page extends StatefulWidget {
  const ${ENTITY_NAME}Page({super.key});

  @override
  State<${ENTITY_NAME}Page> createState() => _${ENTITY_NAME}PageState();
}

class _${ENTITY_NAME}PageState extends State<${ENTITY_NAME}Page> {
  final controller = ${ENTITY_NAME}Controller();
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$ENTITY_NAME')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _form(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Pesquisar'),
              onChanged: (v) => setState(() => busca = v),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<$ENTITY_NAME>>(
              future: controller.listar(busca: busca),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final lista = snapshot.data!;
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final item = lista[i];
                    return ListTile(
                      title: Text(item.${COLS[1]}.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _form(obj: item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await controller.excluir(item.$ID_FIELD);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _form({$ENTITY_NAME? obj}) {
    final controllers = <String, TextEditingController>{};
EOF

for col in "${COLS[@]:1}"; do
  echo "    controllers['$col'] = TextEditingController(text: obj?.$col?.toString() ?? '');" >> "$MODULE_DIR/${TABLE_NAME}_page.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_page.dart" <<EOF

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cadastro'),
        content: SingleChildScrollView(
          child: Column(
            children: controllers.entries.map((e) {
              return TextField(
                controller: e.value,
                decoration: InputDecoration(labelText: e.key),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final novo = $ENTITY_NAME(
                $ID_FIELD: obj?.$ID_FIELD,
EOF

for col in "${COLS[@]:1}"; do
  echo "                $col: controllers['$col']!.text," >> "$MODULE_DIR/${TABLE_NAME}_page.dart"
done

cat >> "$MODULE_DIR/${TABLE_NAME}_page.dart" <<EOF
              );
              await controller.salvar(novo);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
EOF

echo "✅ CRUD de '$TABLE_NAME' gerado com sucesso. Agora para de ser preguiçoso e usa."
