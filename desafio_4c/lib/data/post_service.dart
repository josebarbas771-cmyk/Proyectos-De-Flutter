import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/entities/post.dart';

class PostService {
  static const String _base = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final res = await http.get(Uri.parse('$_base/posts'));
    if (res.statusCode != 200) {
      throw Exception('Error del servidor: ${res.statusCode}');
    }
    final lista = jsonDecode(res.body) as List<dynamic>;
    return lista.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Post> fetchPost(int id) async {
    final res = await http.get(Uri.parse('$_base/posts/$id'));
    if (res.statusCode != 200) {
      throw Exception('No se encontró el post $id (${res.statusCode})');
    }
    return Post.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
