import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';
import '../../domain/entities/post.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Post>> _postsFuture;
  String _busqueda = '';
  void initState() {
    super.initState();
    _postsFuture = _apiService.getPosts();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (texto) {
            setState(() {
              _busqueda = texto;
            });
          },
          decoration: InputDecoration(
            hintText: 'Buscar por título...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando posts...'),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text('Error al cargar los datos'),
                  SizedBox(height: 8),
                  Text('${snapshot.error}',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _postsFuture = _apiService.getPosts();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          final List<Post> todos = snapshot.data!;
          final List<Post> posts =
              todos.where((p) => p.title.contains(_busqueda)).toList();

          if (posts.isEmpty) {
            return const Center(child: Text('No se encontraron posts'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${post.id}'),
                ),
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleScreen(post: post),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
