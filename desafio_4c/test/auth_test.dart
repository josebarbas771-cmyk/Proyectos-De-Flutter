import 'package:flutter_test/flutter_test.dart';

import 'package:desafio4c_gorouter/presentation/auth/auth_notifier.dart';

void main() {
  test('login y logout cambian el estado y notifican', () {
    final auth = AuthNotifier();
    var avisos = 0;
    auth.addListener(() => avisos++);

    expect(auth.estaLogueado, false);
    auth.login('a@a.com');
    expect(auth.estaLogueado, true);
    expect(auth.usuario, 'a@a.com');
    auth.logout();
    expect(auth.estaLogueado, false);
    expect(avisos, 2);
  });
}
