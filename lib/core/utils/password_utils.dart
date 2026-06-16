import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PasswordUtils {
  static String hash(String password) {
    final salt = _generateSalt();
    return '$salt:${_digest(salt, password)}';
  }

  static bool verify(String password, String stored) {
    if (!stored.contains(':')) return stored == password;
    final parts = stored.split(':');
    if (parts.length != 2) return false;
    return _digest(parts[0], password) == parts[1];
  }

  static String _digest(String salt, String password) {
    final bytes = utf8.encode('$salt$password');
    return sha256.convert(bytes).toString();
  }

  static String _generateSalt() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(16, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
