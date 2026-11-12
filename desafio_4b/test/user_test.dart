import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:desafio4b_json/models/user.dart';

void main() {
  const json = '''
  {"id": 1, "name": "Leanne Graham", "username": "Bret",
   "email": "Sincere@april.biz",
   "address": {"city": "Gwenborough", "zipcode": "92998-3874"}}
  ''';

  test('User.fromJson parsea un objeto con address anidado', () {
    final user = User.fromJson(jsonDecode(json) as Map<String, dynamic>);
    expect(user.id, 1);
    expect(user.username, 'Bret');
    expect(user.address.city, 'Gwenborough');
  });

  test('se puede parsear una lista de usuarios', () {
    final lista = jsonDecode('[$json, $json]') as List<dynamic>;
    final users =
        lista.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
    expect(users.length, 2);
  });
}
