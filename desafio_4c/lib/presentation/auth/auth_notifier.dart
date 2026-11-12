import 'package:flutter/foundation.dart';
class AuthNotifier extends ChangeNotifier {
  String? _usuario;

  bool get estaLogueado => _usuario != null;
  String? get usuario => _usuario;

  void login(String usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();
