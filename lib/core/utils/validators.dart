class Validators {
  static String? cpf(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final cpf = value.replaceAll(RegExp(r'\D'), '');
    if (cpf.length != 11) return 'CPF deve ter 11 dígitos';
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return 'CPF inválido';

    int calcDigit(List<int> nums, int factor) {
      var sum = 0;
      for (final n in nums) {
        sum += n * factor--;
      }
      final mod = sum % 11;
      return mod < 2 ? 0 : 11 - mod;
    }

    final digits = cpf.split('').map(int.parse).toList();
    final d1 = calcDigit(digits.sublist(0, 9), 10);
    final d2 = calcDigit(digits.sublist(0, 10), 11);
    if (d1 != digits[9] || d2 != digits[10]) return 'CPF inválido';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'E-mail inválido';
    return null;
  }

  static String? required(String? value, [String field = 'Campo']) {
    if (value == null || value.trim().isEmpty) return '$field é obrigatório';
    return null;
  }

  static String? positiveNumber(String? value, [String field = 'Valor']) {
    if (value == null || value.trim().isEmpty) return null;
    final n = double.tryParse(value.replaceAll(',', '.'));
    if (n == null || n < 0) return '$field inválido';
    return null;
  }

  static String? dateIso(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value.trim())) return 'Use o formato AAAA-MM-DD';
    final parts = value.split('-').map(int.parse).toList();
    final dt = DateTime(parts[0], parts[1], parts[2]);
    if (dt.year != parts[0] || dt.month != parts[1] || dt.day != parts[2]) {
      return 'Data inválida';
    }
    return null;
  }

  static String? dateTimeIso(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$');
    if (!regex.hasMatch(value.trim())) return 'Use AAAA-MM-DD HH:MM';
    return null;
  }

  static String formatCpf(String cpf) {
    final digits = cpf.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return cpf;
    return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
  }
}
