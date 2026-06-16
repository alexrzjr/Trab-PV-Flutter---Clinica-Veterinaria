import 'package:flutter/foundation.dart';

import '../../modules/usuario/usuario_model.dart';
import '../../modules/usuario/usuario_repository.dart';
import '../utils/password_utils.dart';

class AuthProvider extends ChangeNotifier {
  final _repository = UsuarioRepository();
  Usuario? _usuario;

  Usuario? get usuario => _usuario;
  bool get isLoggedIn => _usuario != null;
  bool get isAdmin => _usuario?.perfil == 'admin';

  Future<bool> login(String email, String senha) async {
    final usuario = await _repository.findByEmail(email);
    if (usuario == null) return false;
    if (!PasswordUtils.verify(senha, usuario.senha)) return false;
    _usuario = usuario;
    notifyListeners();
    return true;
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}
