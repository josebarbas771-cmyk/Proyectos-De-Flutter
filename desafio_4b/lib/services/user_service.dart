import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UserService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  Future<User> fetchUser(int id) async {
    final res = await http.get(Uri.parse('$_base/users/$id'));
    if (res.statusCode != 200) {
      throw Exception('Error del servidor: ${res.statusCode}');
    }
    final Map<String, dynamic> json =
        jsonDecode(res.body) as Map<String, dynamic>;
    return User.fromJson(json);
  }
  Future<List<User>> fetchUsers() async {
    final res = await http.get(Uri.parse('$_base/users'));
    if (res.statusCode != 200) {
      throw Exception('Error del servidor: ${res.statusCode}');
    }
    final List<dynamic> lista = jsonDecode(res.body) as List<dynamic>;
    return lista
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
