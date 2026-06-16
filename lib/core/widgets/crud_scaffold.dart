import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum CrudFieldType { text, number, multiline, date, datetime, dropdown, choice }

class CrudField {
  final String key;
  final String label;
  final bool required;
  final CrudFieldType type;
  final TextInputType keyboardType;
  final Future<Map<String, String>> Function()? loadOptions;
  final List<String>? choices;
  final String? Function(String? value)? validator;

  const CrudField({
    required this.key,
    required this.label,
    this.required = false,
    this.type = CrudFieldType.text,
    this.keyboardType = TextInputType.text,
    this.loadOptions,
    this.choices,
    this.validator,
  });

  const CrudField.text({
    required this.key,
    required this.label,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  })  : type = CrudFieldType.text,
        loadOptions = null,
        choices = null;

  const CrudField.number({
    required this.key,
    required this.label,
    this.required = false,
    this.validator,
  })  : type = CrudFieldType.number,
        keyboardType = TextInputType.number,
        loadOptions = null,
        choices = null;

  const CrudField.multiline({
    required this.key,
    required this.label,
    this.required = false,
    this.validator,
  })  : type = CrudFieldType.multiline,
        keyboardType = TextInputType.multiline,
        loadOptions = null,
        choices = null;

  const CrudField.date({
    required this.key,
    required this.label,
    this.required = false,
  })  : type = CrudFieldType.date,
        keyboardType = TextInputType.datetime,
        loadOptions = null,
        choices = null,
        validator = null;

  const CrudField.datetime({
    required this.key,
    required this.label,
    this.required = false,
  })  : type = CrudFieldType.datetime,
        keyboardType = TextInputType.datetime,
        loadOptions = null,
        choices = null,
        validator = null;

  const CrudField.dropdown({
    required this.key,
    required this.label,
    required this.loadOptions,
    this.required = false,
  })  : type = CrudFieldType.dropdown,
        keyboardType = TextInputType.text,
        choices = null,
        validator = null;

  const CrudField.choice({
    required this.key,
    required this.label,
    required this.choices,
    this.required = false,
  })  : type = CrudFieldType.choice,
        keyboardType = TextInputType.text,
        loadOptions = null,
        validator = null;
}

class CrudScaffold<T> extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String searchHint;
  final List<CrudField> fields;
  final Future<List<T>> Function({String? busca}) loadItems;
  final Future<void> Function(T item) saveItem;
  final Future<void> Function(int id) deleteItem;
  final int? Function(T item) getId;
  final String Function(T item) getTitle;
  final String Function(T item) getSubtitle;
  final Map<String, String> Function(T? existing) initialValues;
  final T Function(Map<String, String> values, T? existing) buildItem;
  final String idFieldName;
  final Widget? Function(T item)? trailingExtra;

  const CrudScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.searchHint,
    required this.fields,
    required this.loadItems,
    required this.saveItem,
    required this.deleteItem,
    required this.getId,
    required this.getTitle,
    required this.getSubtitle,
    required this.initialValues,
    required this.buildItem,
    required this.idFieldName,
    this.trailingExtra,
  });

  @override
  State<CrudScaffold<T>> createState() => _CrudScaffoldState<T>();
}

class _CrudScaffoldState<T> extends State<CrudScaffold<T>> {
  String _busca = '';
  int _refreshKey = 0;

  void _reload() => setState(() => _refreshKey++);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(
          title: widget.title,
          subtitle: widget.subtitle,
          icon: widget.icon,
          onAdd: () => _openForm(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _busca.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _busca = ''),
                    )
                  : null,
            ),
            onChanged: (v) => setState(() => _busca = v),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<T>>(
            key: ValueKey('$_refreshKey-$_busca'),
            future: widget.loadItems(busca: _busca),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              final lista = snapshot.data ?? [];
              if (lista.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        'Nenhum registro encontrado',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: lista.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = lista[index];
                  final id = widget.getId(item);
                  final extra = widget.trailingExtra?.call(item);
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          id?.toString() ?? '?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.getTitle(item),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(widget.getSubtitle(item)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (extra != null) extra,
                          IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openForm(existing: item),
                          ),
                          IconButton(
                            tooltip: 'Excluir',
                            icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(T item) async {
    final id = widget.getId(item);
    if (id == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir ${widget.getTitle(item)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await widget.deleteItem(id);
      _reload();
    }
  }

  Future<void> _openForm({T? existing}) async {
    await showDialog(
      context: context,
      builder: (ctx) => _CrudFormDialog<T>(
        title: existing == null ? 'Novo ${widget.title}' : 'Editar ${widget.title}',
        fields: widget.fields,
        initialValues: widget.initialValues(existing),
        buildItem: (values) => widget.buildItem(values, existing),
        onSave: widget.saveItem,
        onDone: () {
          Navigator.pop(ctx);
          _reload();
        },
      ),
    );
  }
}

class _CrudFormDialog<T> extends StatefulWidget {
  final String title;
  final List<CrudField> fields;
  final Map<String, String> initialValues;
  final T Function(Map<String, String> values) buildItem;
  final Future<void> Function(T item) onSave;
  final VoidCallback onDone;

  const _CrudFormDialog({
    required this.title,
    required this.fields,
    required this.initialValues,
    required this.buildItem,
    required this.onSave,
    required this.onDone,
  });

  @override
  State<_CrudFormDialog<T>> createState() => _CrudFormDialogState<T>();
}

class _CrudFormDialogState<T> extends State<_CrudFormDialog<T>> {
  late final Map<String, TextEditingController> _controllers;
  late Map<String, String> _values;
  final Map<String, Map<String, String>> _dropdownCache = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _values = Map.from(widget.initialValues);
    _controllers = {
      for (final f in widget.fields)
        if (f.type != CrudFieldType.dropdown && f.type != CrudFieldType.choice)
          f.key: TextEditingController(text: _values[f.key] ?? ''),
    };
    _loadDropdowns();
  }

  Future<void> _loadDropdowns() async {
    for (final field in widget.fields) {
      if (field.type == CrudFieldType.dropdown && field.loadOptions != null) {
        _dropdownCache[field.key] = await field.loadOptions!();
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(CrudField field) async {
    final current = _values[field.key];
    DateTime initial = DateTime.now();
    if (current != null && current.isNotEmpty) {
      try {
        final p = current.split('-').map(int.parse).toList();
        initial = DateTime(p[0], p[1], p[2]);
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _values[field.key] =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _controllers[field.key]?.text = _values[field.key]!;
      });
    }
  }

  Future<void> _pickDateTime(CrudField field) async {
    final current = _values[field.key];
    DateTime initial = DateTime.now();
    if (current != null && current.contains(' ')) {
      try {
        initial = DateFormat('yyyy-MM-dd HH:mm').parse(current);
      } catch (_) {}
    }
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _values[field.key] = DateFormat('yyyy-MM-dd HH:mm').format(dt);
      _controllers[field.key]?.text = _values[field.key]!;
    });
  }

  String? _validateField(CrudField field, String? value) {
    if (field.required && (value == null || value.trim().isEmpty)) {
      return '${field.label} é obrigatório';
    }
    return field.validator?.call(value);
  }

  Future<void> _save() async {
    final map = <String, String>{};
    for (final field in widget.fields) {
      String value;
      if (field.type == CrudFieldType.dropdown || field.type == CrudFieldType.choice) {
        value = _values[field.key] ?? '';
      } else {
        value = _controllers[field.key]?.text.trim() ?? '';
      }
      final error = _validateField(field, value);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      map[field.key] = value;
    }

    setState(() => _saving = true);
    try {
      final item = widget.buildItem(map);
      await widget.onSave(item);
      widget.onDone();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), backgroundColor: Colors.red.shade700),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.fields.map(_buildField).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Salvar'),
        ),
      ],
    );
  }

  Widget _buildField(CrudField field) {
    final label = field.required ? '${field.label} *' : field.label;

    switch (field.type) {
      case CrudFieldType.dropdown:
        final options = _dropdownCache[field.key] ?? {};
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            value: _values[field.key]?.isNotEmpty == true ? _values[field.key] : null,
            decoration: InputDecoration(labelText: label),
            items: options.entries
                .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (v) => setState(() => _values[field.key] = v ?? ''),
          ),
        );
      case CrudFieldType.choice:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<String>(
            value: _values[field.key]?.isNotEmpty == true ? _values[field.key] : field.choices?.first,
            decoration: InputDecoration(labelText: label),
            items: (field.choices ?? [])
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _values[field.key] = v ?? ''),
          ),
        );
      case CrudFieldType.date:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: _controllers[field.key],
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(field),
              ),
            ),
            onTap: () => _pickDate(field),
          ),
        );
      case CrudFieldType.datetime:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: _controllers[field.key],
            readOnly: true,
            decoration: InputDecoration(
              labelText: label,
              suffixIcon: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _pickDateTime(field),
              ),
            ),
            onTap: () => _pickDateTime(field),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: _controllers[field.key],
            keyboardType: field.type == CrudFieldType.multiline
                ? TextInputType.multiline
                : field.keyboardType,
            maxLines: field.type == CrudFieldType.multiline ? 3 : 1,
            decoration: InputDecoration(labelText: label),
          ),
        );
    }
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onAdd;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Novo'),
          ),
        ],
      ),
    );
  }
}
